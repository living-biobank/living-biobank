class Group < ApplicationRecord
  has_many :users, class_name: "User", foreign_key: :honest_broker_id
  has_many :sources, dependent: :destroy
  has_many :services, dependent: :destroy
end
