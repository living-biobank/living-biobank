class Service < ApplicationRecord
  belongs_to :group
  belongs_to :sparc_service, class_name: "SPARC::Service", foreign_key: :sparc_id

  acts_as_list scope: :group

  validates_uniqueness_of :sparc_id, scope: :group_id

  default_scope { order(:position) }
end
