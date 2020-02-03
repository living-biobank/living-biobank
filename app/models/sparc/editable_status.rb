module SPARC
  class EditableStatus < SPARC::Base
    belongs_to :organization

    def self.statuses
      @statuses ||= PermissibleValue.get_hash('status')
    end

    validates :status, presence: true

    scope :selected, -> { where(selected: true) }

    def self.types
      self.statuses.keys
    end

    def self.defaults
      @defaults ||= PermissibleValue.get_key_list('status', true)
    end

    def humanize
      EditableStatus.statuses[self.status]
    end
  end
end
