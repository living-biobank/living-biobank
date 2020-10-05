class GroupsSource < ApplicationRecord
  belongs_to :source
  belongs_to :group

  validates_presence_of :name
end
