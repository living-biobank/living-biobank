class Lab < ApplicationRecord
  self.per_page = 10

  belongs_to :patient
  belongs_to :line_item, optional: true #This association is for releasing a speciment to a line item
  belongs_to :recipient, class_name: "SPARC::Identity", optional: true
  belongs_to :source

  belongs_to :releaser, source: :user, foreign_key: :released_by

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

  scope :filtered_for_index, -> (term, status, source, sort_by, sort_order) {
    with_status(status).
    with_source(source).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    labs = joins(:patient).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    request_labs = joins(patient: :sparc_requests).where(SparcRequest.arel_table[:protocol_id].matches(term))

    where(id: labs + request_labs)
  }

  scope :with_status, -> (status) {
    if status
      where(status: status)
    else
      where(status: [I18n.t(:labs)[:statuses][:available], I18n.t(:labs)[:statuses][:released]])
    end
  }

  scope :with_source, -> (source) {
    return if source.blank?

    where(source_id: source)
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
