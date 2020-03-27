class Group < ApplicationRecord
  has_and_belongs_to_many :lab_honest_brokers, join_table: :lab_honest_brokers, class_name: "User"

  has_many :sources,    dependent: :destroy
  has_many :services,   dependent: :destroy
  has_many :variables,  dependent: :destroy

  has_many :labs,           through: :sources
  has_many :line_items,     through: :sources
  has_many :sparc_requests, through: :line_items

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_inclusion_of :process_specimen_retrieval, in: [true, false]
end
