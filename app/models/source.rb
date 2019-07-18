class Source < ApplicationRecord
  belongs_to :group

  validates_presence_of :key, :value

  validates_uniqueness_of :key, scope: :group_id
end
