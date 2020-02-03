class Lab < ApplicationRecord
  belongs_to :patient
  belongs_to :line_item, optional: true #This association is for releasing a speciment to a line item
  belongs_to :recipient, class_name: "SPARC::Identity", optional: true
  belongs_to :source

  has_many :populations, through: :patient
  has_many :line_items, -> (lab) { where(source: lab.source) }, through: :populations #This association is for matching specimen sources between labs and line items

  has_one :group, through: :source

  delegate :identifier, to: :patient
  delegate :mrn, to: :patient
  delegate :dob, to: :patient
  delegate :sparc_requests, to: :patient

  scope :usable, -> {
    where(status: [I18n.t(:labs)[:statuses][:available], I18n.t(:labs)[:statuses][:released]]) 
  }

  scope :retrievable, -> (user) {
    if user.honest_broker.process_specimen_retrieval == false
      where(status: [I18n.t(:labs)[:statuses][:available]])
    end
  }

  scope :search, -> (term) {
    return if term.blank?

    labs = joins(:patient).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    request_labs = joins(patient: :sparc_requests).where(SparcRequest.arel_table[:protocol_id].matches(term))

    where(id: labs + request_labs)
  }

  def available?
    self.status == I18n.t(:labs)[:statuses][:available]
  end

  def released?
    self.status == I18n.t(:labs)[:statuses][:released]
  end

  def received?
    self.status == I18n.t(:labs)[:statuses][:received]
  end

  def discarded?
    self.status == I18n.t(:labs)[:statuses][:discarded]
  end
end
