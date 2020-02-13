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
    validates_presence_of :funding_source, if: Proc.new{ |p| p.funded? || p.funding_status.blank? }
    validates_presence_of :potential_funding_source, if: Proc.new{ |p| !p.funded? }

    validate :rmid_valid?, if: :rmid_enabled?

    validates_associated :primary_pi_role

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

    def self.get_rmid(rmid)
      begin
        HTTParty.get("#{SPARC::Setting.get_value('research_master_api')}research_masters/#{rmid}.json",
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => "Token token=\"#{SPARC::Setting.get_value('rmid_api_token')}\""
          })
      rescue
        nil
      end
    end

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

    def pending_funding?
      self.funding_status == 'pending_funding'
    end

    private

    def default_values
      self.next_ssr_id ||= 1
    end

    def rmid_enabled?
      SPARC::Setting.get_value('research_master_enabled') || false
    end

    def rmid_valid?
      rmid_record = SPARC::Protocol.get_rmid(self.research_master_id)

      if rmid_record.nil? || rmid_record['status'] == 404
        errors.add(:research_master_id)
      end
    end
  end
end
