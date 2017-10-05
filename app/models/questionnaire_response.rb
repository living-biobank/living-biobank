class QuestionnaireResponse < ApplicationRecord
  include SparcShard
  belongs_to :submission
  belongs_to :item
  belongs_to :questionnaire
end
