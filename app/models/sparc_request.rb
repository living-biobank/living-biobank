class SparcRequest < ApplicationRecord
  belongs_to :user
  belongs_to :service

  validates :short_title, :title, :funding_status, :funding_source, :start_date, :end_date, :primary_pi_name, :query_name, :service_source, :service_id, presence: true
end
