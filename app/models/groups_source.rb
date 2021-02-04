class GroupsSource < ApplicationRecord
  belongs_to :source
  belongs_to :group

  has_many :line_items

  validates_presence_of :name

  scope :active, -> { where(deprecated: false) }
  scope :inactive, -> { where(deprecated: true) }

  def extended_name
    "#{self.name} (#{self.source.value})"
  end
end
