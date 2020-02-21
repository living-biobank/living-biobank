class Lab < ApplicationRecord
  self.per_page = 10

  belongs_to :patient
  belongs_to :line_item, optional: true #This association is for releasing a speciment to a line item
  belongs_to :recipient, class_name: "SPARC::Identity", optional: true
  belongs_to :source

  belongs_to :releaser, foreign_key: :released_by, class_name: "User", optional: true

  has_many :populations, through: :patient
  has_many :line_items, -> (lab) { where(source: lab.source) }, through: :populations #This association is for matching specimen sources between labs and line items

  has_one :group, through: :source

  delegate :identifier, to: :patient
  delegate :mrn, to: :patient
  delegate :dob, to: :patient
  delegate :sparc_requests, to: :patient

  scope :retrievable, -> (user) {
    if user.honest_broker.process_specimen_retrieval == false
      where(status: [I18n.t(:labs)[:statuses][:available]])
    end
  }

  scope :filtered_for_index, -> (term, released_at_start, released_at_end, status, source, sort_by, sort_order) {
    by_released_date(released_at_start, released_at_end).
    with_status(status).
    with_source(source).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    joins(:releaser, :patient, :source).where("#{Lab.quoted_table_name}.`id` LIKE ?", "#{term}%"
    ).or(
      joins(:releaser, :patient, :source).where(Lab.arel_table[:status].matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Lab.arel_table[:accession_number].matches("%#{term}%"))
    ).or( # Search by Releaser First Name
      joins(:releaser, :patient, :source).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or( # Search by Releaser Last Name
      joins(:releaser, :patient, :source).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or( # Search by Releaser Full Name 
      joins(:releaser, :patient, :source).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Patient.arel_table[:lastname].matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Patient.arel_table[:firstname].matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Patient.arel_table[:identifier].matches("%#{term}%"))
    ).or(
      joins(:releaser, :patient, :source).where(Source.arel_table[:value].matches("%#{term}%"))
    )
  }

  scope :by_released_date, -> (start_date, end_date) {
    return if start_date.blank? && end_date.blank?

    start_date  = DateTime.strptime(start_date, '%m/%d/%Y').beginning_of_day rescue ''
    end_date    = DateTime.strptime(end_date, '%m/%d/%Y').end_of_day rescue ''

    # TODO
    # Implement Between
    if start_date && end_date
      query = Lab.arel_table[:released_at].between(start_date..end_date)
    elsif start_date
      query = Lab.arel_table[:released_at].gteq(start_date)
    else # end_date present, start_date blank
      query = Lab.arel_table[:released_at].lteq(end_date)
    end

    where(query)
  }

  scope :with_status, -> (status) {
    if status
      where(status: status)
    else
      joins(:group).where(
        status: I18n.t(:labs)[:statuses][:available],
        groups: { process_specimen_retrieval: false }
      ).or(
        joins(:group).where(
          status: [I18n.t(:labs)[:statuses][:available], I18n.t(:labs)[:statuses][:released]],
          groups: { process_specimen_retrieval: true }
        )
      )
    end
  }

  scope :with_source, -> (source) {
    return if source.blank?

    where(source_id: source)
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_order = sort_order.present? ? sort_order : 'desc'

    case sort_by
    when 'accession_number'
      joins(:patient).order(Patient.arel_table[:accession_number].send(sort_order), id: :desc)
    when 'specimen_source'
      joins(:source).order(Source.arel_table[:value].send(sort_order), id: :desc)
    else # Includes status
      order(status: sort_order, id: :desc)
    end
  }

  def status=(status)
    [:released, :retrieved, :discarded].each do |s|
      if status == I18n.t(:labs)[:statuses][s]
        self.send("#{s}_at=", DateTime.now)
      end
    end

    super
  end

  def available?
    self.status == I18n.t(:labs)[:statuses][:available]
  end

  def released?
    self.status == I18n.t(:labs)[:statuses][:released]
  end

  def retrieved?
    self.status == I18n.t(:labs)[:statuses][:retrieved]
  end

  def discarded?
    self.status == I18n.t(:labs)[:statuses][:discarded]
  end
end
