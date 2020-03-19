class LineItem < ApplicationRecord
  belongs_to :sparc_request, optional: true
  belongs_to :service, class_name: "SPARC::Service"
  belongs_to :sparc_line_item, class_name: "SPARC::LineItem", foreign_key: :sparc_id, optional: true
  belongs_to :source

  has_many :populations
  has_many :labs

  has_one :sub_service_request, through: :sparc_line_item, class_name: "SPARC::SubServiceRequest"
  has_one :group, through: :source

  validates_presence_of :query_name, :number_of_specimens_requested, :source_id
  validates_numericality_of :number_of_specimens_requested, greater_than: 0, less_than: 10000000, allow_blank: true
  validates_presence_of :minimum_sample_size, if: Proc.new{ |li| li.specimen_request? && li.group.process_sample_size? }
  validates_length_of :minimum_sample_size, maximum: 30, allow_blank: true

  before_destroy :update_sparc_records

  scope :specimen_reqeuests, -> () {
    where.not(source_id: nil)
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
    @progress ||=
      if self.specimen_request?
        if self.labs.loaded?
          labs.select{ |lab| lab.status == I18n.t(:labs)[:statuses][:retrieved] }.length
        else
          labs.where(status: I18n.t(:labs)[:statuses][:retrieved]).count
        end
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
