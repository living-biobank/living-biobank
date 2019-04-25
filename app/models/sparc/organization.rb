module SPARC
  class Organization < SPARC::Base
    belongs_to :parent, class_name: "SPARC::Organization", optional: true

    has_many :services, dependent: :destroy
    has_many :sub_service_requests, dependent: :destroy

    def org_tree
      self.parent ? self.parent.org_tree + [self] : [self]
    end

    def org_tree_display
      self.org_tree.map(&:abbreviation).join('/')
    end
  end
end

