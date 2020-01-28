class LineItem < ApplicationRecord
  belongs_to :sparc_request, optional: true
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

  validates_presence_of :query_name, :number_of_specimens_requested, :source_id
  validates_numericality_of :number_of_specimens_requested, greater_than: 0, if: Proc.new{ |record| record.number_of_specimens_requested.present? }
  validates_presence_of :minimum_sample_size, if: Proc.new{ |li| li.specimen_request? && li.group.process_sample_size? }

  before_destroy :update_sparc_records

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
    @progress ||=
      if self.specimen_request?
        labs.where(status: I18n.t(:labs)[:statuses][:retrieved]).count
      else
        self.sub_service_request.try(:complete?) ? 1 : 0
      end
  end

  def percent_progress
    100 * (self.progress.to_f / self.progress_end)
  end

  private

  def update_sparc_records
    if ssr = self.sub_service_request
      self.sparc_line_item.destroy

      ssr.destroy if ssr.line_items.none?
    end
  end
end
