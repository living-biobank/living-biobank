class SparcRequest < ApplicationRecord
  belongs_to :user
  belongs_to :protocol, class_name: "SPARC::Protocol"

  has_one :primary_pi, through: :protocol, class_name: "SPARC::Identity"

  has_many :line_items, dependent: :destroy

  delegate :identifier, :start_date, :end_date, to: :protocol

  accepts_nested_attributes_for :line_items, allow_destroy: true
  accepts_nested_attributes_for :protocol

  scope :active, -> { where.not(status: I18n.t(:requests)[:statuses][:cancelled]) }

  scope :draft, -> { where(status: I18n.t(:requests)[:statuses][:draft]) }

  scope :with_status, -> (status) {
    where(status: status) if status
  }

  scope :filtered_for_index, -> (term, status, sort_by, sort_order) {
    where.not(status: I18n.t(:requests)[:statuses][:draft]).
      search(term).
      with_status(status).
      ordered_by(sort_by, sort_order)
  }

  scope :search, -> (term) {
    return if term.blank?

    joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:short_title].matches("%#{term}%")).or(
      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:title].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:funding_status].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:funding_source].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:potential_funding_source].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(arel_table[:status].matches("%#{term}%"))
    ).or(
      by_date(term)
    ).or(
      joins(:protocol, line_items: :service).where(LineItem.arel_table[:service_source].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(LineItem.arel_table[:query_name].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(LineItem.arel_table[:minimum_sample_size].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(LineItem.arel_table[:number_of_specimens_requested].matches(term))
    ).or(
      joins(:protocol, line_items: :service).where(SPARC::Service.arel_table[:name].matches("%#{term}%"))
    ).or(
      joins(:protocol, line_items: :service).where(SPARC::Service.arel_table[:abbreviation].matches("%#{term}%"))
    ).distinct
  }

  scope :by_date, -> (date) {
    return none if date.blank?

    parsed_date = Date.parse(date).to_s rescue nil

    if parsed_date
      date = date.delete("/").delete("-")
      mdy = Date.strptime(date, '%m%d%Y')
      dmy = Date.strptime(date, '%d%m%Y')
      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:start_date].matches(mdy)).or(
        joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:end_date].matches(mdy))
      ).or(
        joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:start_date].matches(dmy))
      ).or(
        joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:end_date].matches(dmy))
      )
    elsif date =~ /\A\d+\Z/
      start = Date.parse("1-1-#{date}")
      last  = Date.parse("31-12-#{date}")

      joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:start_date].gteq(start).and(SPARC::Protocol.arel_table[:start_date].lteq(last))).or(
        joins(:protocol, line_items: :service).where(SPARC::Protocol.arel_table[:end_date].gteq(start).and(SPARC::Protocol.arel_table[:end_date].lteq(last)))
      )
    else
      joins(:protocol, line_items: :service).none
    end
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_order = sort_order.present? ? sort_order : 'desc'

    case sort_by
    when 'title', 'short_title'
      joins(:protocol).order(SPARC::Protocol.arel_table[sort_by].send(sort_order))
    when 'protocol_id'
      joins(:protocol).order(SPARC::Protocol.arel_table[:id].send(sort_order))
    when 'time_remaining'
      joins(:protocol).order(SPARC::Protocol.arel_table[:end_date].send(sort_order))
    when 'primary_pi'
      joins(protocol: :primary_pi).order(SPARC::Identity.arel_table[:last_name].send(sort_order))
    when 'requester'
      joins(:user).order(User.arel_table[:last_name].send(sort_order))
    else # Includes status
      order(status: sort_order)
    end
  }

  before_save :update_sparc_records

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

  def pi_display_name
    "#{primary_pi_name} ( #{primary_pi_email} )" if primary_pi_name && primary_pi_email
  end

  private

  def update_sparc_records
    sr        = self.protocol.service_requests.first_or_create
    requester = SPARC::Directory.find_or_create(self.user.net_id)

    self.line_items.eager_load(:service).each do |line_item|
      service = line_item.service

      unless ssr = sr.sub_service_requests.where(organization: service.process_ssrs_organization).first
        ssr = sr.sub_service_requests.create(
          protocol:           self.protocol,
          organization:       service.process_ssrs_organization,
          service_requester:  requester
        )
      end

      sparc_li = ssr.line_items.first_or_create(
        service_request:  sr,
        service:          service,
        optional:         true
      )

      line_item.sparc_id = sparc_li.id
    end
  end
end
