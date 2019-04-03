class Lab < ApplicationRecord
  belongs_to :patient

  delegate :mrn, to: :patient
  delegate :sparc_requests, to: :patient

  scope :available, -> {
    where(removed: false)
  }

  scope :search, -> (term) {
    return if term.blank?

    labs = joins(:patient).where(Patient.arel_table[:mrn].matches("%#{term}%"))
    request_labs = joins(patient: :sparc_requests).where(SparcRequest.arel_table[:protocol_id].matches(term))

    where(id: labs + request_labs)
  }
end
