class SparcRequest < ApplicationRecord
  belongs_to :user
  belongs_to :service
  belongs_to :protocol, optional: true

  validates :title,
            :description,
            :funding_status,
            :funding_source,
            :start_date,
            :end_date,
            :primary_pi_name,
            :query_name,
            :service_source,
            :service_id,
            :minimum_sample_size,
            :number_of_specimens_requested,
            presence: true

  scope :active, -> { where.not(status: 'Cancelled') }
end
