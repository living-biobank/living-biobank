class SpecimenRequest < ApplicationRecord
  has_many :populations
  has_many :specimens
  has_many :labs, through: :specimens
  has_many :patients, through: :populations
end
