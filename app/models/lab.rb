class Lab < ApplicationRecord
  belongs_to :patient
  belongs_to :specimen
end
