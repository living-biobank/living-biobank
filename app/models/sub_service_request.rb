class SubServiceRequest < ApplicationRecord
  include SparcShard
  has_many :line_items
end
