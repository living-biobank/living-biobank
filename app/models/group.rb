class Group < ApplicationRecord
  has_many :users, class_name: "User", foreign_key: :honest_broker_id
  has_many :sources, dependent: :destroy
  has_many :services, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_inclusion_of :process_specimen_retrieval, in: [true, false]
end
