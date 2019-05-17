module SPARC
  class Protocol < SPARC::Base
    has_one :primary_pi_role, -> { where(role: 'primary-pi', project_rights: 'approve') }, class_name: "ProjectRole"
    has_one :primary_pi, through: :primary_pi_role, source: :identity

    has_many :sparc_requests
    has_many :specimen_records

    has_many :project_roles
    has_many :service_requests
    has_many :sub_service_requests

    validates_presence_of :research_master_id, if: :rmid_enabled?
    validates_presence_of :short_title, :title, :funding_status, :start_date, :end_date, :next_ssr_id
    validates_presence_of :funding_source, if: Proc.new{ |p| p.funded? }
    validates_presence_of :potential_funding_source, if: Proc.new{ |p| !p.funded? }

    accepts_nested_attributes_for :primary_pi_role

    before_validation :default_values

    scope :search, -> (term) {
      where("#{SPARC::Protocol.quoted_table_name}.`id` LIKE ?", "#{term}%"
      ).or(
        where(SPARC::Protocol.arel_table[:short_title].matches("%#{term}%"))
      ).or(
        where(SPARC::Protocol.arel_table[:title].matches("%#{term}%"))
      ).or(
        where(SPARC::Protocol.arel_identifier(:short_title).matches("%#{term}%"))
      ).or(
        where(SPARC::Protocol.arel_identifier(:title).matches("%#{term}%"))
      )
    }

    def self.arel_identifier(field)
      SPARC::Protocol.arel_table[:id].concat(Arel::Nodes.build_quoted(' - ')).concat(SPARC::Protocol.arel_table[field])
    end

    def identifier
      "#{self.id} - " +
        if self.short_title.present?
          self.short_title
        elsif self.title.present?
          self.title
        else
          I18n.t(:requests)[:draft][:placeholder]
        end
    end

    def funded?
      self.funding_status == 'funded'
    end

    private

    def default_values
      self.next_ssr_id ||= 1
    end

    def rmid_enabled?
      SPARC::Setting.get_value('research_master_enabled') || false
    end
  end
end
