class Population < ApplicationRecord
  belongs_to :line_item
  belongs_to :patient
end
