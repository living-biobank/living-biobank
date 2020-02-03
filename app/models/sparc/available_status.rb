module SPARC
  class AvailableStatus < SPARC::Base
    belongs_to :organization

    scope :selected, -> { where(selected: true) }

    def disabled_status?
      ["Draft", "Get a Cost Estimate", "Submitted"].include?(self.humanize)
    end

    def self.statuses
      @statuses ||= PermissibleValue.get_hash('status')
    end

    def self.defaults
      @defaults ||= PermissibleValue.get_key_list('status', true)
    end

    def humanize
      AvailableStatus.statuses[self.status]
    end

    def self.types
      self.statuses.keys
    end

    def editable_status
      EditableStatus.find_by(organization_id: organization_id, status: status)
    end
  end
end
