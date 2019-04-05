class LineItem < ApplicationRecord
  belongs_to :sparc_request
  belongs_to :service, class_name: "SPARC::Service"

  has_many :populations
  has_many :specimen_records, -> (line_item) {
    unscope(:where).where(
      protocol_id: line_item.sparc_request.protocol_id,
      service_id: line_item.service_id,
      service_source: line_item.service_source
    )
  }

  validates_presence_of :service_id, :service_source, :minimum_sample_size, :number_of_specimens_requested
  validates_numericality_of :number_of_specimens_requested, greater_than: 0

  def percent_progress
    100 * self.specimen_records.count / self.number_of_specimens_requested.to_f
  end
end
