module SPARC
  class Service < SPARC::Base
    belongs_to :organization

    has_many :line_items, class_name: "::LineItem"
    has_many :sparc_line_items, class_name: "SPARC::LineItem", dependent: :destroy
    has_many :pricing_maps, class_name: "SPARC::PricingMap", dependent: :destroy

    scope :search, -> (term) {
      where(SPARC::Service.arel_table[:name].matches("%#{term}%")
      ).or(
        where(SPARC::Service.arel_table[:abbreviation].matches("%#{term}%"))
      ).or(
        where(SPARC::Service.arel_table[:description].matches("%#{term}%"))
      ).or(
        where(SPARC::Service.arel_table[:cpt_code].matches("%#{term}%"))
      ).where(is_available: true)
    }

    def display_service_name
      service_name  = self.name
      service_name += " (#{self.cpt_code})" unless self.cpt_code.blank?
      service_name
    end

    def process_ssrs_organization
      org = self.organization

      while !org.process_ssrs
        org = org.parent
      end

      org
    end

    def parents(id_only=false)
      parent_org = id_only ? organization.id : organization
      [parent_org] + organization.parents(id_only)
    end

    # Service belongs to Organization A, which belongs to
    # Organization B, which belongs to Organization C, return "C > B > A".
    # This "hierarchy" stops at a process_ssrs Organization.
    def organization_hierarchy(include_self=false, process_ssrs=true, use_css=false, use_array=false)
      parent_orgs = self.parents.reverse

      if process_ssrs
        root = parent_orgs.find_index { |org| org.process_ssrs? } || (parent_orgs.length - 1)
      else
        root = parent_orgs.length - 1
      end

      if use_array
        parent_orgs[0..root]
      elsif use_css
        parent_orgs[0..root].map{ |o| "<span class='#{o.css_class}-text'>#{o.abbreviation}</span>"}.join('<span> / </span>') + (include_self ? '<span> / </span>' + "<span>#{self.abbreviation}</span>" : '')
      else
        parent_orgs[0..root].map(&:abbreviation).join(' > ') + (include_self ? ' > ' + self.abbreviation : '')
      end
    end
  end
end
