class Source < ApplicationRecord
  
  has_many :groups_sources
  has_many :groups, through: :groups_sources
  has_many :labs
  has_many :line_items

  validates_presence_of :key, :value
end
