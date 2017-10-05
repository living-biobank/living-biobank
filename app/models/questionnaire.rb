class Questionnaire < ApplicationRecord
  include SparcShard

  belongs_to :questionable, polymorphic: :true
  has_many :items
  has_many :submissions
end
