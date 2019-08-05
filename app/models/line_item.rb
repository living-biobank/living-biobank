class LineItem < ApplicationRecord
  belongs_to :sparc_request
  belongs_to :service, class_name: "SPARC::Service"
  belongs_to :sparc_line_item, class_name: "SPARC::LineItem", foreign_key: :sparc_id, optional: true
  belongs_to :source

  has_many :populations
  has_many :labs
  has_many :specimen_records, -> (line_item) {
    unscope(:where).where(
      protocol_id: line_item.sparc_request.protocol_id,
      service_id: line_item.service_id,
      source_id: line_item.source_id
    )
  }

  has_one :sub_service_request, through: :sparc_line_item, class_name: "SPARC::SubServiceRequest"
  has_one :group, through: :source

  validates_presence_of :query_name, :number_of_specimens_requested
  validates_presence_of :minimum_sample_size, if: Proc.new{ |li| li.specimen_request? && li.group.process_sample_size? }

  validates_numericality_of :number_of_specimens_requested, greater_than: 0

  scope :specimen_requests, -> {
    where.not(source_id: nil)
  }

  scope :additional_services, -> {
    where(source_id: nil)
  }

  def specimen_request?
    self.source_id.present?
  end

  def complete?
    self.progress == self.progress_end
  end

  def progress_start
    0
  end

  def progress_end
    self.specimen_request? ? self.number_of_specimens_requested : 1
  end

  def progress
    if self.specimen_request?
      labs.where(status: I18n.t(:labs)[:statuses][:retrieved]).count
    else
      self.sub_service_request.complete? ? 1 : 0
    end
  end

  def percent_progress
    100 * (self.progress.to_f / self.progress_end)
  end
end
