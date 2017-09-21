class QuestionnaireResponse < ApplicationRecord
  include SparcShard
  belongs_to :submission
end
