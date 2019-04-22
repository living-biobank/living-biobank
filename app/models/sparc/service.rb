module SPARC
  class Service < SPARC::Base
    belongs_to :organization

    has_many :line_items, class_name: "::LineItem"
    has_many :sparc_line_items, class_name: "SPARC::LineItem"

    def process_ssrs_organization
      org = self.organization

      while !org.process_ssrs
        org = org.parent
      end

      org
    end
  end
end
