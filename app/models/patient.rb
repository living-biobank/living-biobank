class Patient < ApplicationRecord
  has_many :populations
  has_many :specimen_requests, through: :populations
  has_many :labs
end
