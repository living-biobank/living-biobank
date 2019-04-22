module SPARC
  class ServiceRequest < SPARC::Base
    belongs_to :protocol

    has_many :sub_service_requests
    has_many :line_items

    validates_presence_of :status

    before_validation :default_values

    private

    def default_values
      self.status ||= 'draft'
    end
  end
end
