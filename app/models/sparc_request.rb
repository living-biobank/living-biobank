class SparcRequest < ApplicationRecord
  self.per_page = 10

  belongs_to :user
  belongs_to :protocol, class_name: "SPARC::Protocol"

  has_one :primary_pi, through: :protocol, class_name: "SPARC::Identity"

  has_many :line_items, dependent: :destroy
  has_many :specimen_requests, -> { where.not(source_id: nil) }, class_name: "LineItem"
  has_many :additional_services, -> { where(source_id: nil) }, class_name: "LineItem"
  has_many :sources, through: :specimen_requests
  has_many :groups, through: :sources
  has_many :services, through: :groups, source: :services
  has_many :variables, through: :groups

  validates :specimen_requests, length: { minimum: 1 }

  validates_associated :specimen_requests

  delegate :title, :short_title, :identifier, :start_date, :end_date, to: :protocol

  accepts_nested_attributes_for :specimen_requests, allow_destroy: true
  accepts_nested_attributes_for :protocol

  after_save :update_variables, if: :pending?
  after_save :update_sparc_records, unless: :draft?

  after_update :add_additional_services, if: :in_process?

  scope :in_process, -> { where(status: I18n.t(:requests)[:statuses][:in_process]) }

  scope :draft, -> { where(status: I18n.t(:requests)[:statuses][:draft]) }

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

    eager_load(:user, specimen_requests: :source).where(protocol_id: queried_protocol_ids).
    where(SparcRequest.arel_table[:status].matches("%#{term}%")
    ).or( # Search by Releaser First Name
      eager_load(:user, specimen_requests: :source).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or( # Search by Releaser Last Name
      eager_load(:user, specimen_requests: :source).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or( # Search by Releaser Full Name 
      eager_load(:user, specimen_requests: :source).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      eager_load(:user, specimen_requests: :source).where(LineItem.arel_table[:query_name].matches("%#{term}%"))
    )
    .or(
      eager_load(:user, specimen_requests: :source).where(Source.arel_table[:value].matches("%#{term}%"))
    )
  }

  scope :with_status, -> (status) {
    if status.blank?
      where(status: [I18n.t(:requests)[:statuses][:pending], I18n.t(:requests)[:statuses][:in_process]])
    elsif status == 'any'
      where.not(status: I18n.t(:requests)[:statuses][:draft])
    else
      where(status: status)
    end
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_order = sort_order.present? ? sort_order : 'desc'

    case sort_by
    when 'title', 'short_title'
      protocol_ids = SPARC::Protocol.where(id: pluck(:protocol_id)).order(SPARC::Protocol.arel_table[sort_by].send(sort_order), created_at: :desc).ids
      order(SparcRequest.send(:sanitize_sql_array, ['FIELD(protocol_id, ?)', protocol_ids])).where(protocol_id: protocol_ids)
    when 'protocol_id'
      order(protocol_id: sort_order)
    when 'time_remaining'
      protocol_ids = SPARC::Protocol.where(id: pluck(:protocol_id)).order(SPARC::Protocol.arel_table[:end_date].send(sort_order), created_at: :desc).ids
      order(SparcRequest.send(:sanitize_sql_array, ['FIELD(protocol_id, ?)', protocol_ids])).where(protocol_id: protocol_ids)
    when 'primary_pi'
      protocol_ids = SPARC::Protocol.joins(:primary_pi).where(id: pluck(:protocol_id)).order(SPARC::Identity.arel_table[:last_name].send(sort_order), created_at: :desc).ids
      order(SparcRequest.send(:sanitize_sql_array, ['FIELD(protocol_id, ?)', protocol_ids])).where(protocol_id: protocol_ids)
    when 'requester'
      joins(:user).order(User.arel_table[:last_name].send(sort_order), created_at: :desc)
    else # Includes status
      order(status: sort_order, created_at: :desc)
    end
  }

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

  # Friendly named for Variables

  def irb_approved
    rmid = self.protocol.research_master_id
    SPARC::Protocol.get_rmid(rmid)['eirb_validated'].present?
  end

  def irb_not_approved
    !irb_approved
  end

  private

  def update_variables
    # Find or create a Service Request
    sr = self.protocol.service_requests.first_or_create
    # Find or create an Identity for the requester
    requester = SPARC::Directory.find_or_create(self.user.net_id)

    # Add additional services based on services the Variable requires
    self.variables.each do |variable|
      if self.instance_eval(variable.condition)
        unless self.additional_services.exists?(service: variable.service)
          line_item = self.additional_services.create(service: variable.service)
          create_sparc_line_item(line_item, sr, requester)
        end
      end
    end
  end

  def update_sparc_records
    # Find or create a Service Request
    sr = self.protocol.service_requests.first_or_create
    # Find or create an Identity for the requester
    requester = SPARC::Directory.find_or_create(self.user.net_id)

    self.specimen_requests.includes(:service).each{ |li| create_sparc_line_item(li, sr, requester) }
  end

  def add_additional_services
    # Find or create a Service Request
    sr = self.protocol.service_requests.first_or_create
    # Find or create an Identity for the requester
    requester = SPARC::Directory.find_or_create(self.user.net_id)

    # Add additional services based on services the Group provides
    self.services.each do |service|
      unless self.additional_services.exists?(service: service.sparc_service)
        line_item = self.additional_services.create(service: service.sparc_service)
        create_sparc_line_item(line_item, sr, requester)
      end
    end
  end

  def create_sparc_line_item(line_item, sr, requester)
    service = line_item.service

    # Find or create a Sub Service Request for the SPARC Line Item
    if ssr = sr.sub_service_requests.where(organization: service.process_ssrs_organization).detect{ |ssr| !ssr.complete? }
      ssr.update_attribute(:status, 'draft')
    else
      ssr = sr.sub_service_requests.create(
        protocol:           self.protocol,
        organization:       service.process_ssrs_organization,
        service_requester:  requester
      )
    end

    # Find or create a SPARC Line Item for the Line Item
    sparc_li = ssr.line_items.where(
      service: service,
    ).first_or_create(
      service_request:  sr,
      optional:         true
    )

    line_item.update_attribute(:sparc_id, sparc_li.id)
  end
end
