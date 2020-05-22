module SPARC
  class SubServiceRequest < SPARC::Base
    belongs_to :organization
    belongs_to :protocol, counter_cache: true
    belongs_to :service_request
    belongs_to :service_requester, class_name: "SPARC::Identity"

    has_many :line_items, dependent: :destroy

    validates_presence_of :ssr_id, :status, :org_tree_display

    before_validation :default_values, on: :create

    def complete?
      SPARC::Setting.get_value('finished_statuses').include?(self.status) && organization.has_editable_status?(self.status)
    end

    def locked?
      !organization.has_editable_status?(status)
    end

    def display_id
      "#{protocol.id}-#{self.ssr_id}"
    end

    private

    def default_values
      self.protocol.increment!(:next_ssr_id) unless self.ssr_id
      self.status           ||= 'draft'
      self.ssr_id           ||= "%04d" % (self.protocol.next_ssr_id - 1)
      self.org_tree_display ||= self.organization.org_tree_display
    end
  end
end
