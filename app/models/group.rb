class Group < ApplicationRecord
  has_and_belongs_to_many :lab_honest_brokers, join_table: :lab_honest_brokers, class_name: "User"

  has_many :sources,    dependent: :destroy
  has_many :services,   dependent: :destroy
  has_many :variables,  dependent: :destroy

  has_many :labs,           through: :sources
  has_many :line_items,     through: :sources
  has_many :sparc_requests, through: :line_items

  has_rich_text :release_email
  has_rich_text :discard_email

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :release_email
  validates_presence_of :discard_email, if: :process_specimen_retrieval?

  validates_inclusion_of :process_specimen_retrieval,         in: [true, false]
  validates_inclusion_of :notify_when_all_specimens_released, in: [true, false]
  validates_inclusion_of :process_sample_size,                in: [true, false]
  validates_inclusion_of :display_patient_information,        in: [true, false]

  scope :filtered_for_index, -> (term, sort_by, sort_order) {
    search(term).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_order = sort_order.present? ? sort_order : 'desc'
    return
  }
end
