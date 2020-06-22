class SparcRequest < ApplicationRecord
  include DirtyAssociations

  belongs_to :requester, class_name: "User", foreign_key: :user_id
  belongs_to :updater, class_name: "User", foreign_key: :updated_by, optional: true
  belongs_to :finalizer, class_name: "User", foreign_key: :finalized_by, optional: true
  belongs_to :completer, class_name: "User", foreign_key: :completed_by, optional: true
  belongs_to :canceller, class_name: "User", foreign_key: :cancelled_by, optional: true
  belongs_to :protocol, class_name: "SPARC::Protocol"

  has_one :primary_pi, through: :protocol, class_name: "SPARC::Identity"

  has_many :line_items, dependent: :destroy
  has_many :specimen_requests, -> { where.not(source_id: nil) }, class_name: "LineItem"
  has_many :additional_services, -> { where(source_id: nil) }, class_name: "LineItem", after_add: :dirty_create, after_remove: :dirty_delete
  has_many :sources, through: :specimen_requests
  has_many :groups, through: :sources
  has_many :services, through: :groups, source: :services
  has_many :variables, through: :groups

  validates_presence_of :dr_consult, unless: :draft?

  validates_associated :protocol
  validates_associated :specimen_requests

  validates :specimen_requests, length: { minimum: 1 }

  delegate :title, :short_title, :start_date, :end_date, to: :protocol

  accepts_nested_attributes_for :specimen_requests, allow_destroy: true
  accepts_nested_attributes_for :protocol

  after_save :add_authorized_users,       if: Proc.new{ |sr| sr.draft? || (sr.pending? && !self.updated?) }
  after_save :update_variables,           if: :active?
  after_save :update_additional_services, if: :in_process?
  after_save :send_finalization_emails,   if: :in_process?
  after_save :send_locked_emails,         if: :active?

  scope :active,      -> { where(status: [I18n.t(:requests)[:statuses][:pending], I18n.t(:requests)[:statuses][:in_process]]) }
  scope :in_process,  -> { where(status: I18n.t(:requests)[:statuses][:in_process]) }
  scope :draft,       -> { where(status: I18n.t(:requests)[:statuses][:draft]) }

  scope :filtered_for_index, -> (term, status, sort_by, sort_order) {
    search(term).
    with_status(status).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    queried_protocol_ids = SPARC::Protocol.where(SPARC::Protocol.arel_table[:id].matches("#{term}%")
    ).or(
      SPARC::Protocol.where(SPARC::Protocol.arel_table[:short_title].matches("%#{term}%"))
    ).or(
      SPARC::Protocol.where(SPARC::Protocol.arel_table[:title].matches("%#{term}%"))
    ).or(
      SPARC::Protocol.where(SPARC::Protocol.arel_identifier(:short_title).matches("%#{term}%"))
    ).or(
      SPARC::Protocol.where(SPARC::Protocol.arel_identifier(:title).matches("%#{term}%"))
    ).or(
      SPARC::Protocol.where(SPARC::Protocol.arel_identifier(:title).matches("%#{term}%"))
    ).ids

    eager_load(:requester, specimen_requests: :source).where(protocol_id: queried_protocol_ids
    ).or(
      eager_load(:requester, specimen_requests: :source).where(SparcRequest.arel_table[:status].matches("%#{term}%")
    )
    ).or(
      eager_load(:requester, specimen_requests: :source).where(SparcRequest.arel_table[:id].matches("#{term.to_i}%"))
    ).or( # Search by Releaser First Name
      eager_load(:requester, specimen_requests: :source).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or( # Search by Releaser Last Name
      eager_load(:requester, specimen_requests: :source).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or( # Search by Releaser Full Name 
      eager_load(:requester, specimen_requests: :source).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      eager_load(:requester, specimen_requests: :source).where(LineItem.arel_table[:query_name].matches("%#{term}%"))
    )
    .or(
      eager_load(:requester, specimen_requests: :source).where(Source.arel_table[:value].matches("%#{term}%"))
    )
  }

  scope :with_status, -> (status) {
    status = status.blank? ? 'active' : status

    if status == 'any'
      where.not(status: I18n.t(:requests)[:statuses][:draft])
    elsif status == 'active'
      active
    else
      where(status: status)
    end
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'created_at' : sort_by
    sort_order  = sort_order.blank? ? 'desc' : sort_order

    case sort_by
    when 'title', 'short_title'
      protocol_ids = SPARC::Protocol.where(id: pluck(:protocol_id)).order(SPARC::Protocol.arel_table[sort_by].send(sort_order), created_at: :desc).ids
      order(SparcRequest.send(:sanitize_sql_array, ['FIELD(protocol_id, ?)', protocol_ids])).where(protocol_id: protocol_ids)
    when 'protocol_id'
      order(protocol_id: sort_order)
    when 'time_remaining'
      protocol_ids = SPARC::Protocol.where(id: pluck(:protocol_id)).order(SPARC::Protocol.arel_table[:end_date].send(sort_order), created_at: :desc).ids
      order(SparcRequest.send(:sanitize_sql_array, ['FIELD(protocol_id, ?)', protocol_ids])).where(protocol_id: protocol_ids)
    when 'requester'
      joins(:requester).order(User.arel_table[:last_name].send(sort_order), created_at: :desc)
    when 'status'
      order(status: sort_order, created_at: :desc)
    else
      order(sort_by => sort_order)
    end
  }

  def status=(status)
    case status
    when I18n.t(:requests)[:statuses][:pending]
      if self.submitted_at.blank?
        self.send("submitted_at=", DateTime.now)
      end
    when I18n.t(:requests)[:statuses][:in_process]
      self.send("finalized_at=", DateTime.now)
    when I18n.t(:requests)[:statuses][:completed]
      self.send("completed_at=", DateTime.now)
    when I18n.t(:requests)[:statuses][:cancelled]
      self.send("cancelled_at=", DateTime.now)
    end

    super(status)
  end

  def updated?
    self.updated_at > self.created_at && self.updater
  end

  def active?
    self.pending? || self.in_process?
  end

  def completed?
    self.status == I18n.t(:requests)[:statuses][:completed]
  end

  def in_process?
    self.status == I18n.t(:requests)[:statuses][:in_process]
  end

  def pending?
    self.status == I18n.t(:requests)[:statuses][:pending]
  end

  def draft?
    self.status == I18n.t(:requests)[:statuses][:draft]
  end

  def cancelled?
    self.status == I18n.t(:requests)[:statuses][:cancelled]
  end

  def previously_submitted?
    self.submitted_at.present?
  end

  def previously_finalized?
    self.finalized_at.present?
  end

  def identifier
    self.id ? "%04d" % self.id : ""
  end

  # Friendly named for Variables

  def irb_approved
    if @approved.nil?
      rmid      = self.protocol.research_master_id
      @approved = SPARC::Protocol.get_rmid(rmid)['eirb_validated'].present?
    end

    @approved
  end

  def irb_not_approved
    !irb_approved
  end

  def add_authorized_users
    # Add Data Honest Brokers
    email = ENV.fetch('SPARC_MANAGERS').split(',').map do |net_id|
      identity = SPARC::Directory.find_or_create(net_id)

      unless self.protocol.project_roles.exists?(identity: identity)
        self.protocol.project_roles.create(
          identity: identity,
          project_rights: 'approve',
          role:           'other',
          role_other:     'Living BioBank Manager'
        )
      end

      RequestMailer.with(request: self, user: identity).manager_email.deliver_later
    end
  end

  def update_variables
    # Find or create a Service Request
    sr = self.protocol.service_requests.first_or_create
    # Find or create an Identity for the requester
    requester = SPARC::Directory.find_or_create(self.requester.net_id)

    # Add additional services based on services the Variable requires
    self.variables.each do |variable|
      if self.instance_eval(variable.condition)
        unless self.additional_services.exists?(service: variable.service)
          line_item = self.additional_services.create(service: variable.service)
          create_sparc_line_item(line_item, sr, requester)
        end
      end
    end

    self.additional_services.where.not(service_id: [nil] + self.services.pluck(:sparc_id) + self.variables.pluck(:service_id)).destroy_all
  end

  def update_additional_services
    # Find or create a Service Request
    sr = self.protocol.service_requests.first_or_create
    # Find or create an Identity for the requester
    requester = SPARC::Directory.find_or_create(self.requester.net_id)

    # Add additional services based on services the Group provides
    self.services.each do |service|
      unless self.additional_services.exists?(service: service.sparc_service)
        line_item = self.additional_services.create(service: service.sparc_service)
        create_sparc_line_item(line_item, sr, requester)
      end
    end

    self.additional_services.where.not(service_id: [nil] + self.services.pluck(:sparc_id) + self.variables.pluck(:service_id)).destroy_all
  end

  def send_finalization_emails
    self.groups.each do |g|
      if g.finalize_email.present? && g.finalize_email_to.present?
        RequestMailer.with(group: g, request: self).finalization_email.deliver_later
      end
    end
  end

  def send_locked_emails
    locked_services = SPARC::Service.eager_load(organization: { parent: { parent: :parent } }).where(id: self.additional_services.where(id: self.saved_changes[:line_item][:added], sparc_id: nil).pluck(:service_id))

    SPARC::SubServiceRequest.eager_load(:organization).where(protocol_id: self.protocol_id, organization_id: locked_services.pluck(:organization_id)).distinct.reject(&:complete?).each do |ssr|
      services = locked_services.select{ |s| s.process_ssrs_organization.id == ssr.organization_id }

      if email = ssr.organization.submission_emails.last.try(:email)
        RequestMailer.with(sub_service_request: ssr, request: self, services: services, to: email).locked_email.deliver_later
      elsif ssr.organization.service_providers.any?
        ssr.organization.service_providers.eager_load(:identity).each do |sp|
          RequestMailer.with(sub_service_request: ssr, request: self, services: services, user: sp.identity).locked_email.deliver_later
        end
      end
    end
  end

  private

  def create_sparc_line_item(line_item, sr, requester)
    service = line_item.service

    # Find or create a Sub Service Request for the SPARC Line Item
    ssr = sr.sub_service_requests.where(organization: service.process_ssrs_organization).detect{ |ssr| !ssr.complete? }

    if ssr.nil?
      ssr = sr.sub_service_requests.create(
        protocol:           self.protocol,
        organization:       service.process_ssrs_organization,
        service_requester:  requester
      )
    elsif !ssr.locked?
      ssr.update_attribute(:status, 'draft')
    end

    # Do not add services in SPARC if the SSR is locked
    unless ssr.locked?
      # Find or create a SPARC Line Item for the Line Item
      unless sparc_li = ssr.line_items.where(service: service).first
        sparc_li = ssr.line_items.create(
          service:          service,
          service_request:  sr,
          quantity:         1,
          optional:         true
        )
      end

      line_item.update_attribute(:sparc_id, sparc_li.id)
    end
  end
end
