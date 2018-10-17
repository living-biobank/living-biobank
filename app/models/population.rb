class Population < ApplicationRecord
  belongs_to :sparc_request
  belongs_to :patient
end
