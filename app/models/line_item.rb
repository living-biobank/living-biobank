class LineItem < ApplicationRecord
  acts_as_paranoid
  belongs_to :sparc_request, optional: true
  belongs_to :service, class_name: "SPARC::Service", optional: true
  belongs_to :sparc_line_item, class_name: "SPARC::LineItem", foreign_key: :sparc_id, optional: true
  belongs_to :groups_source, optional: true
  
  belongs_to :i2b2_query, class_name: "I2b2::Query", foreign_key: :musc_query_id, primary_key: :query_master_id, optional: true
  alias_attribute :query_id, :musc_query_id

  belongs_to :shrine_query, class_name: "Shrine::Query", foreign_key: :act_query_id, primary_key: :id, optional: true
  has_many :populations
  has_many :labs

  has_one :protocol, through: :sparc_request
  has_one :sub_service_request, through: :sparc_line_item, class_name: "SPARC::SubServiceRequest"
  has_one :group, through: :groups_source
  has_one :source, through: :groups_source

  validates_presence_of     :number_of_specimens_requested, 
                            :groups_source_id,                                    
                              if: :specimen_request?

  # These validations ensure that either an musc query or a shrine query is present for a given line item
  validate :musc_query_presence, :act_query_presence

  validates_numericality_of :number_of_specimens_requested, greater_than: 0, less_than: 10000000, allow_blank: true,  if: :specimen_request?
  validates_numericality_of :minimum_sample_size, greater_than: 0, less_than: 10000000,                               if: Proc.new{ |li| li.specimen_request? && li.group && li.group.process_sample_size? }

  before_destroy :update_sparc_records
  before_create :specimen_check
  after_create :set_position

  scope :specimen_requests, -> () {
    where.not(groups_source_id: nil)
  }

  scope :additional_services, -> () {
    where(groups_source_id: nil)
  }

  def specimen_request?
    self.groups_source_id.present? || self.service_id.nil?
  end

  def specimen_check
    # Exists only until specimens and non-specimens are split out
    if self.groups_source_id.present?
      self.specimen = true
    end
  end

  def set_position
    if self.specimen?
      next_position = self.sparc_request.line_items.with_deleted.where(specimen: true).maximum(:position).to_i + 1
      self.update_attribute(:position, next_position)
    end
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
          labs.select{ |lab| self.group.process_specimen_retrieval? ? lab.retrieved? : lab.released? }.length
        else
          labs.where(status: self.group.process_specimen_retrieval? ? I18n.t(:labs)[:statuses][:retrieved] : I18n.t(:labs)[:statuses][:released]).count
        end
      else
        self.sub_service_request.try(:complete?) ? 1 : 0
      end
  end

  def percent_progress
    100 * (self.progress.to_f / self.progress_end)
  end

  def position_display
    "%03d" % self.position
  end

  def specimen_identifier
    "#{self.sparc_request.identifier}-#{self.position_display}"
  end

  private

  def musc_query_presence
    if act_query_id.blank?
      if musc_query_id.blank?
        errors.add(:query, "must be included")
      end
    end
  end

  def act_query_presence
    if musc_query_id.blank?
      if act_query_id.blank?
        errors.add(:query, "must be included")
      end
    end
  end

  def update_sparc_records
    if ssr = self.sub_service_request
      self.sparc_line_item.destroy

      ssr.destroy if ssr.line_items.none?
    end
  end
end
