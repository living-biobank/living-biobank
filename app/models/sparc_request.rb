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
            :primary_pi_email,
            :service_id,
            :service_source,
            :number_of_specimens_requested,
            :minimum_sample_size,
            :query_name,
            :status,
            presence: true

  validates_format_of :primary_pi_email, with: /\A[A-Za-z0-9]*@musc.edu\Z/

  scope :active, -> { where.not(status: 'Cancelled') }

  scope :draft, -> { where(status: 'Draft') }

  scope :with_status, -> (status) {
    where(status: status) if status
  }

  def complete?
    self.status == I18n.t(:requests)[:statuses][:finalized]
  end

  def draft?
    self.status == I18n.t(:requests)[:statuses][:draft]
  end

  def cancelled?
    self.status == I18n.t(:requests)[:statuses][:cancelled]
  end
end
