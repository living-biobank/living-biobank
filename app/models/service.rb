class Service < ApplicationRecord
  belongs_to :group
  belongs_to :sparc_service, class_name: "SPARC::Service", foreign_key: :sparc_id

  validates_uniqueness_of :sparc_id, scope: :group_id
end