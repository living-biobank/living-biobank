class Submission < ApplicationRecord
  include SparcShard
  belongs_to :line_item
end
