module SPARC
  class Organization < SPARC::Base
    belongs_to :parent, class_name: "SPARC::Organization", optional: true

    has_many :services, dependent: :destroy
    has_many :service_providers, dependen: :destroy
    has_many :sub_service_requests, dependent: :destroy
    has_many :available_statuses, dependent: :destroy
    has_many :editable_statuses, dependent: :destroy
    has_many :submission_emails, dependent: :destroy

    def org_tree
      self.parent ? self.parent.org_tree + [self] : [self]
    end

    def org_tree_display
      self.org_tree.map(&:abbreviation).join('/')
    end

    # Returns an array of organizations, the current organization's parents, in order of climbing
    # the tree backwards (thus if called on a core it will return => [program, provider, institution]).
    def parents(id_only=false)
      my_parents = []
      if parent
        my_parents << (id_only ? parent.id : parent)
        my_parents.concat(parent.parents(id_only))
      end

      my_parents
    end

    # Returns the first organization amongst the current organization's parents where the process_ssrs
    # flag is set to true.  Will return self if self has the flag set true.  Will return nil if no
    # organization in the hierarchy is found that has the flag set to true.
    def process_ssrs_parent
      self.process_ssrs? ? self : self.parents.detect{ |o| o.process_ssrs? }
    end

    def has_editable_status?(status)
      get_editable_statuses.include?(status)
    end

    def get_editable_statuses
      if process_ssrs
        if self.use_default_statuses
          AvailableStatus.defaults
        else
          if self.editable_statuses.loaded?
            self.editable_statuses.select{ |es| es.selected? }.map(&:status)
          else
            self.editable_statuses.selected.pluck(:status)
          end
        end
      elsif process_ssrs_parent
        process_ssrs_parent.get_editable_statuses
      else
        AvailableStatus.defaults
      end
    end
  end
end

