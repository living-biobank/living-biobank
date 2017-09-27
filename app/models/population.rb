class Population < ApplicationRecord
  belongs_to :specimen_request
  belongs_to :patient
end
