class Specimen < ApplicationRecord
  belongs_to :specimen_request
  has_many :labs
end
