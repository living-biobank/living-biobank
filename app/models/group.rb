class Group < ApplicationRecord
  has_and_belongs_to_many :lab_honest_brokers, join_table: :lab_honest_brokers, class_name: "User"

  has_many :sources,    dependent: :destroy
  has_many :services,   dependent: :destroy
  has_many :variables,  dependent: :destroy

  has_many :labs,           through: :sources
  has_many :line_items,     through: :sources
  has_many :sparc_requests, through: :line_items

  has_rich_text :release_email

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :release_email

  validates_inclusion_of :process_specimen_retrieval,         in: [true, false]
  validates_inclusion_of :notify_when_all_specimens_released, in: [true, false]
  validates_inclusion_of :process_sample_size,                in: [true, false]
  validates_inclusion_of :display_patient_information,        in: [true, false]
end
