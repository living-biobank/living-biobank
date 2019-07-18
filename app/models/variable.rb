class Variable < ApplicationRecord
  belongs_to :group
  belongs_to :service, class_name: "SPARC::Service", foreign_key: :sparc_id
end
