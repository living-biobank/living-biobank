class SpecimenRequest < ApplicationRecord
  has_many :populations
  has_many :specimens
  has_many :labs, through: :specimens
  has_many :patients, through: :populations
  belongs_to :line_item
  belongs_to :protocol
end
