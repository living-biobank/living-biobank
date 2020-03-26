class Lab < ApplicationRecord
  self.per_page = 10

  belongs_to :patient
  belongs_to :line_item, optional: true #This association is for releasing a speciment to a line item
  belongs_to :releaser, foreign_key: :released_by, class_name: "User", optional: true
  belongs_to :recipient, class_name: "SPARC::Identity", optional: true
  belongs_to :source

  has_many :populations, through: :patient
  # This association is for matching specimen sources between labs and line items
  has_many :line_items, -> (lab) { where(source: lab.source) }, through: :populations

  has_one :group, through: :source
  has_one :sparc_request, through: :line_item

  delegate :identifier, to: :patient
  delegate :mrn, to: :patient
  delegate :dob, to: :patient
  delegate :sparc_requests, to: :patient

  after_update :send_emails

  scope :filtered_for_index, -> (term, released_at_start, released_at_end, status, source, sort_by, sort_order) {
    search(term).
    by_released_date(released_at_start, released_at_end).
    with_status(status).
    with_source(source).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    # Because we have to join on sparc_request: :protocol, these are released labs
    queried_released_labs = joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where("#{Lab.quoted_table_name}.`id` LIKE ?", "#{term}%"
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Lab.arel_table[:status].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Lab.arel_table[:accession_number].matches("%#{term}%"))
    ).or( # Search by Releaser First Name
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or( # Search by Releaser Last Name
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or( # Search by Releaser Full Name 
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Patient.arel_table[:lastname].matches("%#{term}%").and(Group.arel_table[:display_patient_information].eq(true)))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Patient.arel_table[:firstname].matches("%#{term}%").and(Group.arel_table[:display_patient_information].eq(true)))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Patient.arel_table[:identifier].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(Source.arel_table[:value].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where("#{SPARC::Protocol.quoted_table_name}.`id` LIKE ?", "#{term}%")
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(SPARC::Protocol.arel_table[:short_title].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(SPARC::Protocol.arel_table[:title].matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(SPARC::Protocol.arel_identifier(:short_title).matches("%#{term}%"))
    ).or(
      joins(sparc_request: :protocol).eager_load(:releaser, :patient, source: :group).where(SPARC::Protocol.arel_identifier(:title).matches("%#{term}%"))
    )

    # Now try to brute force find available labs matching the query by loading associations and using Ruby code
    # Note: We can't eager_load the :line_items associations because it's instance-dependent, so we have to use
    # Ruby to avoid n+1 queries to the database
    labs_from_scope   = includes(populations: :line_item).select{ |lab| lab.line_item_id.nil? }
    eligible_requests = SparcRequest.joins(:protocol).where(
      id: labs_from_scope.map do |lab|
        pops = lab.populations.select{ |pop| pop.line_item.source_id == lab.source_id }
        pops.map(&:line_item).map(&:sparc_request_id)
      end.flatten.uniq
    )

    queried_eligible_request_ids = eligible_requests.where("#{SPARC::Protocol.quoted_table_name}.`id` LIKE ?", "#{term}%"
    ).or(
      eligible_requests.where(SPARC::Protocol.arel_table[:short_title].matches("%#{term}%"))
    ).or(
      eligible_requests.where(SPARC::Protocol.arel_table[:title].matches("%#{term}%"))
    ).or(
      eligible_requests.where(SPARC::Protocol.arel_identifier(:short_title).matches("%#{term}%"))
    ).or(
      eligible_requests.where(SPARC::Protocol.arel_identifier(:title).matches("%#{term}%"))
    ).ids

    queried_available_labs = where(
      id: labs_from_scope.select do |lab|
        pops = lab.populations.select{ |pop| pop.line_item.source_id == lab.source_id }
        (pops.map(&:line_item).map(&:sparc_request_id) & queried_eligible_request_ids).any?
      end
    )

    # Now combine all of the labs together and that's our result
    where(id: queried_released_labs.ids + queried_available_labs.ids)
  }

  scope :by_released_date, -> (start_date, end_date) {
    return if start_date.blank? && end_date.blank?

    start_date  = DateTime.strptime(start_date, '%m/%d/%Y').beginning_of_day rescue ''
    end_date    = DateTime.strptime(end_date, '%m/%d/%Y').end_of_day rescue ''

    if start_date.present? && end_date.present?
      where(Lab.arel_table[:released_at].between(start_date..end_date))
    elsif start_date.present?
      where(Lab.arel_table[:released_at].gteq(start_date))
    else # end_date present, start_date blank
      where(Lab.arel_table[:released_at].lteq(end_date))
    end
  }

  scope :with_status, -> (status) {
    return if status == 'any'

    if status.blank?
      joins(:group).where(
        status: I18n.t(:labs)[:statuses][:available],
        groups: { process_specimen_retrieval: false }
      ).or(
        joins(:group).where(
          status: [I18n.t(:labs)[:statuses][:available], I18n.t(:labs)[:statuses][:released]],
          groups: { process_specimen_retrieval: true }
        )
      )
    else
      where(status: status)
    end
  }

  scope :with_source, -> (source) {
    return if source.blank?

    where(source_id: source)
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_order = sort_order.present? ? sort_order : 'desc'

    case sort_by
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

  private

  def send_emails
    # Leaving this open to expansion for now because Bashir wants
    # retrieval emails too in a future story
    if self.released?
      SpecimenMailer.release_email(self.sparc_request).deliver_now
    end
  end
end
