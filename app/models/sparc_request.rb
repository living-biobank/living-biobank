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
  has_many :specimen_requests, -> { where.not(groups_source_id: nil) }, class_name: "LineItem"
  has_many :additional_services, -> { where(groups_source_id: nil) }, class_name: "LineItem", after_add: :dirty_create, after_remove: :dirty_delete
  has_many :groups_sources, through: :specimen_requests
  has_many :groups, through: :groups_sources
  has_many :services, through: :groups

  validates_presence_of :dr_consult, unless: :draft?

  validates_associated :protocol
  validates_associated :specimen_requests
  validates_associated :primary_pi

  validates :specimen_requests, length: { minimum: 1 }

  delegate :title, :short_title, :start_date, :end_date, to: :protocol

  accepts_nested_attributes_for :specimen_requests, allow_destroy: true
  accepts_nested_attributes_for :protocol

  before_save :create_external_user, if: Proc.new{ |sr| sr.requester.external?}
  before_save :create_external_protocol, if: Proc.new{ |sr| sr.requester.external?}

  after_save :add_authorized_users,       if: Proc.new{ |sr| sr.pending? && !self.updated? }
  after_save :update_services
  after_save :send_finalization_emails,   if: :in_process?
  after_save :send_locked_emails,         if: :active?

  scope :active,      -> { where(status: %w(pending in_process)) }
  scope :in_process,  -> { where(status: 'in_process') }
  scope :draft,       -> { where(status: 'draft') }

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
    )
    .or(
      eager_load(:requester, specimen_requests: :source).where(Source.arel_table[:value].matches("%#{term}%"))
    )
  }

  scope :with_status, -> (status) {
    status = status.blank? ? 'active' : status

    if status == 'any'
      where.not(status: 'draft')
    elsif status == 'active'
      active
    else
      where(status: status)
    end
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'submitted_at' : sort_by
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

  def self.to_csv
    request_attributes = ['id', 'status', 'created_at']

    protocol_id_attribute = ['sparc_number']
    protocol_attributes = ['research_master_id', 'short_title', 'start_date', 'end_date']

    primary_pi_attribute = ['Primary PI']
    requester_attribute = ['Requester']

    ###Here, we have an arbitrary number of potential line items for any given request.  So this section deals with figuring out how many columns we'll need.
    count_array = []
    all.each do |sr|
      count_array << sr.specimen_requests.count
    end
    
    max_line_item_count = count_array.max

    line_item_attributes = []
    
    unless max_line_item_count == nil
      if max_line_item_count > 1
        for a in 1..max_line_item_count do
          line_item_attributes << ["Line Item ID #{a}", "Line Item Group #{a}", "Line Item Specimen #{a}", "Line Item Requested Amount #{a}"]
        end
      elsif max_line_item_count == 1
        line_item_attributes << ["Line Item ID 1", "Line Item Group 1", "Line Item Specimen 1", "Line Item Requested Amount 1"]
      end
    end

    complete_attributes = request_attributes + protocol_id_attribute + protocol_attributes + primary_pi_attribute + requester_attribute + line_item_attributes.flatten

    ####And now we put it all together###
    CSV.generate(headers: true) do |csv|
      csv << complete_attributes

      all.each do |sr|
        csv << request_attributes.map{ |attr| sr.send(attr) } + [sr.protocol.id] + protocol_attributes.map{|attr| sr.protocol.send(attr)} + [sr.primary_pi.full_name] + [sr.requester.full_name] + sr.specimen_requests.map{|li| 
          [li.specimen_identifier ? li.specimen_identifier : nil, 
          li.groups_source.group.name ? li.groups_source.group.name : nil, 
          li.groups_source.source.value ? li.groups_source.source.value : nil, 
          li.number_of_specimens_requested ? li.number_of_specimens_requested : nil]}.flatten
      end
    end
  end

  def status=(status)
    case status
    when 'pending'
      if self.submitted_at.blank?
        self.send("submitted_at=", DateTime.now)
      end
    when 'in_process'
      self.send("finalized_at=", DateTime.now)
    when 'complete'
      self.send("completed_at=", DateTime.now)
    when 'cancelled'
      self.send("cancelled_at=", DateTime.now)
    end
    super(status)
  end

  def human_status
    I18n.t("requests.statuses.#{self.status}")
  end

  def updated?
    self.updated_at > self.created_at && self.updater
  end

  def active?
    self.pending? || self.in_process?
  end

  def completed?
    self.status == 'complete'
  end

  def in_process?
    self.status == 'in_process'
  end

  def pending?
    self.status == 'pending'
  end

  def draft?
    self.status == 'draft'
  end

  def cancelled?
    self.status == 'cancelled'
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
      @approved = SPARC::Protocol.get_rmid(rmid).try(:[], 'eirb_validated').present?
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

  def update_services
    if (services_to_add = self.services.where(status: self.status).order(:position)).any?
      # Find or create a Service Request
      sr = self.protocol.service_requests.first_or_create
      # Find or create an Identity for the requester if an internal user.  Otherwise, find the requester identity that was created prior to saving the request
      sparc_user = 
        if requester.internal?
          SPARC::Directory.find_or_create(self.requester.net_id)
        else
          SPARC::Identity.where(last_name: requester.last_name, first_name: requester.first_name, email:  requester.email).first
        end

      services_to_add.each do |serv|
        if (serv.condition.blank? || self.instance_eval(serv.condition)) && !self.additional_services.exists?(service: serv.sparc_service)
          line_item = self.additional_services.create(service: serv.sparc_service)
          create_sparc_line_item(line_item, sr, sparc_user)
        end
      end

      self.additional_services.where.not(service_id: [nil] + self.services.pluck(:sparc_id)).destroy_all
    end
  end

  def send_finalization_emails
    self.groups.each do |g|
      if g.finalize_email.present? && g.finalize_email_to.present?
        RequestMailer.with(group: g, request: self).finalization_email.deliver_later
      end
    end
  end

  def send_locked_emails
    if self.saved_changes[:line_item] && self.saved_changes[:line_item][:added]
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
  end

  private

  def create_external_user
    #Find or create external identity for SPARC
    identity = SPARC::Identity.where(last_name: requester.last_name, first_name: requester.first_name, email:  requester.email)

    unless identity.present?
      SPARC::Identity.create(last_name: requester.last_name, first_name: requester.first_name, email:  requester.email)
    end
  end

  def create_external_protocol
    #Check if the protocol record has an id attached to it as a proxy for record existence in SPARC, else begin creation process
    unless protocol.id.present?
      
      #Check to see if the Primary PI is already in SPARC else, create new identity
      primary_pi_identity = SPARC::Identity.where(
        last_name: protocol.primary_pi_role.identity.last_name, 
        first_name: protocol.primary_pi_role.identity.first_name, 
        email:  protocol.primary_pi_role.identity.email
      ) 

      primary_pi_identity ||=
        SPARC::Identity.create(
          last_name: protocol.primary_pi_role.identity.last_name, 
          first_name: protocol.primary_pi_role.identity.first_name, 
          email:  protocol.primary_pi_role.identity.email
        )

      #Now, create the protocol
      new_protocol = SPARC::Protocol.create(
        type: "Project", 
        title: protocol.title, 
        short_title: protocol.short_title, 
        sponsor_name: protocol.sponsor_name, 
        funding_status: protocol.funding_status, 
        funding_source: protocol.funding_source, 
        potential_funding_source: protocol.potential_funding_source, 
        start_date: protocol.start_date, 
        end_date: protocol.end_date 
      )

      #Create the primary pi protocol role for the new protocol
      new_protocol.project_roles.create({identity: primary_pi_identity, role: "primary-pi", project_rights: "approve"})
    end
  end

  def create_sparc_line_item(line_item, sr, sparc_user)
    service = line_item.service

    # Find or create a Sub Service Request for the SPARC Line Item
    ssr = sr.sub_service_requests.where(organization: service.process_ssrs_organization).detect{ |ssr| !ssr.complete? }

    if ssr.nil?
      ssr = sr.sub_service_requests.create(
        protocol:           self.protocol,
        organization:       service.process_ssrs_organization,
        service_requester:  sparc_user
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
