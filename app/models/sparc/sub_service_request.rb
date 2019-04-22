module SPARC
  class SubServiceRequest < SPARC::Base
    belongs_to :organization
    belongs_to :protocol
    belongs_to :service_request
    belongs_to :service_requester, class_name: "SPARC::Identity"

    has_many :line_items

    validates_presence_of :ssr_id, :status, :org_tree_display

    before_validation :default_values

    private

    def default_values
      self.protocol.increment!(:next_ssr_id) unless self.ssr_id
      self.status           ||= 'draft'
      self.ssr_id           ||= "%04d" % (self.protocol.next_ssr_id - 1)
      self.org_tree_display ||= self.organization.org_tree_display
    end
  end
end