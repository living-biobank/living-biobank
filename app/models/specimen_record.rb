class SpecimenRecord < ApplicationRecord
  belongs_to :service
  belongs_to :protocol

  validates :protocol_id,
            :release_date,
            :release_to,
            :quantity,
            :service_source,
            :service_id,
            presence: true

  validates_numericality_of :quantity
end
