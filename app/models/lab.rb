class Lab < ApplicationRecord
  belongs_to :patient
  has_many :specimen_records

  def self.unreleased_labs
    where.not(id: SpecimenRecord.all.pluck(:lab_id))
  end

  def protocols
    patient.specimen_requests.map(&:sparc_protocol_id)
  end

  def specimen_requests
    patient.specimen_requests.map(&:id)
  end

  def mrn
    patient.mrn
  end
end
