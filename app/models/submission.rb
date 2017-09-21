class Submission < ApplicationRecord
  include SparcShard
  belongs_to :line_item
  has_many :questionnaire_responses
end
