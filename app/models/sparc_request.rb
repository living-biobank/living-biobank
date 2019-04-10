class SparcRequest < ApplicationRecord
  belongs_to :user
  belongs_to :protocol, class_name: "SPARC::Protocol", optional: true

  has_many :line_items, dependent: :destroy

  delegate :identifier, to: :protocol

  validates :short_title,
            :title,
            :description,
            :funding_status,
            :funding_source,
            :start_date,
            :end_date,
            :primary_pi_netid,
            :primary_pi_name,
            :primary_pi_email,
            :status,
            presence: true

  validates_format_of :primary_pi_email, with: /\A[A-Za-z0-9]*@musc.edu\Z/

  accepts_nested_attributes_for :line_items, allow_destroy: true

  scope :active, -> { where.not(status: 'Cancelled') }

  scope :draft, -> { where(status: 'Draft') }

  scope :search, -> (term) {
    return if term.blank?

    joins(line_items: :service).where(arel_table[:short_title].matches("%#{term}%")).or(
      joins(line_items: :service).where(arel_table[:title].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:funding_status].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:funding_source].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:primary_pi_netid].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:primary_pi_name].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:primary_pi_email].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(arel_table[:status].matches("%#{term}%"))
    ).or(
      by_date(term)
    ).or(
      joins(line_items: :service).where(LineItem.arel_table[:service_source].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(LineItem.arel_table[:query_name].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(LineItem.arel_table[:minimum_sample_size].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(LineItem.arel_table[:number_of_specimens_requested].matches(term))
    ).or(
      joins(line_items: :service).where(SPARC::Service.arel_table[:name].matches("%#{term}%"))
    ).or(
      joins(line_items: :service).where(SPARC::Service.arel_table[:abbreviation].matches("%#{term}%"))
    ).distinct
  }

  scope :by_date, -> (date) {
    return none if date.blank?

    parsed_date = Date.parse(date).to_s rescue nil

    if parsed_date
      date = date.delete("/").delete("-")
      mdy = Date.strptime(date, '%m%d%Y')
      dmy = Date.strptime(date, '%d%m%Y')
      joins(line_items: :service).where(arel_table[:start_date].matches(mdy)).or(
        joins(line_items: :service).where(arel_table[:end_date].matches(mdy))
      ).or(
        joins(line_items: :service).where(arel_table[:start_date].matches(dmy))
      ).or(
        joins(line_items: :service).where(arel_table[:end_date].matches(dmy))
      )
    elsif date =~ /\A\d+\Z/
      start = Date.parse("1-1-#{date}")
      last  = Date.parse("31-12-#{date}")

      joins(line_items: :service).where(arel_table[:start_date].gteq(start).and(arel_table[:start_date].lteq(last))).or(
        joins(line_items: :service).where(arel_table[:end_date].gteq(start).and(arel_table[:end_date].lteq(last)))
      )
    else
      joins(line_items: :service).none
    end
  }

  scope :with_status, -> (status) {
    where(status: status) if status
  }

  scope :filtered_for_index, -> (term, status, sort_by, sort_order) {
    where.not(status: I18n.t(:requests)[:statuses][:draft]).
      search(term).
      with_status(status).
      order((sort_by || :status) => (sort_order.blank? ? :desc : sort_order))
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

  def pi_display_name
    "#{primary_pi_name} ( #{primary_pi_email} )" if primary_pi_name && primary_pi_email
  end


end
