class Lab < ApplicationRecord
  belongs_to :patient

  has_many :specimen_records

  delegate :mrn, to: :patient
  delegate :specimen_requests, to: :patient

  scope :available, -> {
    where(removed: false)
  }

  scope :unreleased, -> {
    where.not(id: SpecimenRecord.all.pluck(:lab_id))
  }

  def protocols
    patient.specimen_requests.pluck(:protocol_id)
  end
end
