class SpecimenRecord < ApplicationRecord
  belongs_to :lab

  validates :protocol_id, :release_date, :release_to, presence: true
end
