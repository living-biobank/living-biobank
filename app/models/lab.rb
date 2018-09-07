class Lab < ApplicationRecord
  belongs_to :patient

  delegate :mrn, to: :patient
  delegate :specimen_requests, to: :patient

  scope :available, -> {
    where(removed: false)
  }
end
