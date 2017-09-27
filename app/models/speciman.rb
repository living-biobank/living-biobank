class Speciman < ApplicationRecord
  belongs_to :specimen_request
  belongs_to :lab_id
end
