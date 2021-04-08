class Lab < ApplicationRecord
  belongs_to :patient
  belongs_to :line_item, optional: true #This association is for releasing a specimen to a line item
  belongs_to :releaser, foreign_key: :released_by, class_name: "User", optional: true
  belongs_to :discarder, foreign_key: :discarded_by, class_name: "User", optional: true
  belongs_to :recipient, class_name: "SPARC::Identity", optional: true
  belongs_to :source

  has_many :populations, through: :patient
  # This association is for matching specimen sources between labs and line items
  has_many :line_items, -> (lab) { where(groups_source: [lab.source.groups_sources]) }, through: :populations

  has_one :groups_source, through: :line_item
  has_one :group, through: :groups_source
  has_one :sparc_request, through: :line_item

  after_update :send_emails

  delegate :identifier, to: :patient
  delegate :mrn, to: :patient
  delegate :dob, to: :patient

  alias_attribute :collection_date, :specimen_date

  scope :filtered_for_index, -> (term, specimen_date_start, specimen_date_end, status, source, sort_by, sort_order) {
    search(term).
    by_specimen_date(specimen_date_start, specimen_date_end).
    with_status(status).
    with_source(source).
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

    # Because we have to join on sparc_request: :protocol, these are released labs
    queried_released_labs = joins(:releaser, sparc_request: :requester).where(SparcRequest.arel_table[:protocol_id].in(queried_protocol_ids)
    ).or(
      joins(:releaser, sparc_request: :requester).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or(
      joins(:releaser, sparc_request: :requester).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or(
      joins(:releaser, sparc_request: :requester).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      joins(:releaser, sparc_request: :requester).where(SparcRequest.arel_table[:id].matches("#{term.to_i}%"))
    )



    # released_labs_by_sparc_id = joins(:releaser, sparc_request: :requester).where(SparcRequest.arel_table[:id].matches("%#{term}%"))

    # Now try to brute force find available labs matching the query by loading associations and using Ruby code
    # Note: We can't eager_load the :line_items associations because it's instance-dependent, so we have to use
    # Ruby to avoid n+1 queries to the database
    labs_from_scope   = includes(populations: { line_item: :source }).select{ |lab| lab.line_item_id.nil? }
    eligible_requests = SparcRequest.where(
      id: labs_from_scope.map do |lab|
        pops = lab.populations.select{ |pop| pop.line_item.source.id == lab.source_id }
        pops.map(&:line_item).map(&:sparc_request_id)
      end.flatten.uniq
    )

    queried_eligible_protocol_ids = SPARC::Protocol.where(SPARC::Protocol.arel_table[:id].matches("#{term}%")
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

    queried_eligible_request_ids = eligible_requests.joins(:requester).where(SparcRequest.arel_table[:protocol_id].in(queried_eligible_protocol_ids)
    ).or(
      joins(:requester).where(User.arel_table[:first_name].matches("%#{term}%"))
    ).or(
      joins(:requester).where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or(
      joins(:requester).where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      joins(:requester).where(SparcRequest.arel_table[:id].matches("#{term.to_i}%"))
    ).ids

    queried_available_labs = where(
      id: labs_from_scope.select do |lab|
        pops = lab.populations.select{ |pop| pop.line_item.source.id == lab.source_id }
        (pops.map(&:line_item).map(&:sparc_request_id) & queried_eligible_request_ids).any?
      end
    )

    # Now combine all of the labs together and that's our result
    joins(:patient, :source).where(id: queried_released_labs.ids + queried_available_labs.ids
    ).or(
      joins(:patient, :source).where(Lab.arel_table[:id].matches("#{term.to_i}%"))
    ).or(
      joins(:patient, :source).where(Lab.arel_table[:status].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Lab.arel_table[:accession_number].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Patient.arel_table[:lastname].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Patient.arel_table[:firstname].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Patient.arel_table[:identifier].matches("%#{term}%"))
    ).or(
      joins(:patient, :source).where(Source.arel_table[:value].matches("%#{term}%"))
    )
  }

  scope :by_specimen_date, -> (start_date, end_date) {
    return if start_date.blank? && end_date.blank?

    start_date  = DateTime.strptime(start_date, '%m/%d/%Y').beginning_of_day rescue ''
    end_date    = DateTime.strptime(end_date, '%m/%d/%Y').end_of_day rescue ''

    if start_date.present? && end_date.present?
      where(Lab.arel_table[:specimen_date].between(start_date..end_date))
    elsif start_date.present?
      where(Lab.arel_table[:specimen_date].gteq(start_date))
    else # end_date present, start_date blank
      where(Lab.arel_table[:specimen_date].lteq(end_date))
    end
  }

  scope :with_status, -> (status) {
    status = status.blank? ? 'active' : status
    return if status == 'any'

    if status == 'active'
      includes(:group).where(
        status: 'available'
      ).or(
        includes(:group).where(
          status: 'released',
          groups: { process_specimen_retrieval: true }
        )
      )
    else
      where(status: status)
    end
  }

  scope :with_source, -> (source) {
    source = source.blank? ? 'any' : source
    return if source == 'any'

    where(source_id: source)
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'id' : sort_by
    sort_order  = sort_order.blank? ? 'desc' : sort_order

    case sort_by
    when 'specimen_source'
      joins(:source).order(Source.arel_table[:value].send(sort_order), id: :desc)
    when 'status' # Includes status
      order(status: sort_order, id: :desc)
    else
      order(sort_by => sort_order)
    end
  }

  scope :available, -> { where(status: 'available') }

  def status=(status)
    self.send("#{status}_at=", DateTime.now) if self.respond_to?("#{status}_at=".to_sym)
    super(status)
  end

  def eligible_line_items
    self.line_items.joins(:groups_source).where(GroupsSource.arel_table[:discard_age].gteq((Date.today - self.specimen_date.to_date).to_i))
  end

  def human_status
    I18n.t("labs.statuses.#{self.status}")
  end

  def available?
    self.status == 'available'
  end

  def released?
    self.status == 'released'
  end

  def retrieved?
    self.status == 'retrieved'
  end

  def discarded?
    self.status == 'discarded'
  end

  def identifier
    "%04d" % self.id
  end

  def send_emails
    if self.released? && (!self.groups_source.group.notify_when_all_specimens_released? || self.line_item.complete?)
      SpecimenMailer.with(specimen: self, request: self.sparc_request).release_email.deliver_now
    end

    if self.discarded? && self.sparc_request && !self.groups_source.group.notify_when_all_specimens_released?
      SpecimenMailer.with(specimen: self, request: self.sparc_request).discard_email.deliver_now
    end
  end
end
