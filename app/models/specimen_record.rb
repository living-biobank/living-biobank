class SpecimenRecord < ApplicationRecord
  validates :protocol_id,
            :release_date,
            :release_to,
            :quantity,
            :service_source,
            :service_id,
            presence: true

  validates_numericality_of :quantity
end
