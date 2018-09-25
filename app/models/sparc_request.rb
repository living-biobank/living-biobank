class SparcRequest < ApplicationRecord
  belongs_to :user
  belongs_to :service
  belongs_to :protocol, optional: true

  validates :short_title,
            :title,
            :description,
            :funding_status,
            :funding_source,
            :start_date,
            :end_date,
            :primary_pi_name,
            :service_id,
            :service_source,
            :number_of_specimens_requested,
            :minimum_sample_size,
            :query_name,
            :status,
            presence: true

  scope :active, -> { where.not(status: 'Cancelled') }
end
