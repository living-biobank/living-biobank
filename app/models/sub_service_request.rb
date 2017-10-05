class SubServiceRequest < ApplicationRecord
  include SparcShard
  has_many :line_items
  belongs_to :protocol
end
