class Variable < ApplicationRecord
  belongs_to :group
  belongs_to :service, class_name: "SPARC::Service"

  has_many :sparc_requests

  validates_presence_of :name

  validates_uniqueness_of :name, scope: :group_id
end
