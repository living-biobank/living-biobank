class Source < ApplicationRecord
  belongs_to :group

  has_many :labs
  has_many :line_items

  validates_presence_of :key, :value

  validates_uniqueness_of :key, scope: :group_id
end
