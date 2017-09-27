class Specimen < ApplicationRecord
  belongs_to :specimen_request
  belongs_to :lab
end
