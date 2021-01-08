class LabHonestBroker < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user_id, scope: [:group_id]

  scope :filtered_for_index, -> (term, sort_by, sort_order) {
    where(user: User.filtered_for_index(term, nil, nil, sort_by, sort_order))
  }
end
