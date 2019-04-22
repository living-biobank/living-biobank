module SPARC
  class Protocol < SPARC::Base
    has_one :primary_pi_role, -> { where(role: 'primary-pi', project_rights: 'approve') }, class_name: "ProjectRole"
    has_one :primary_pi, through: :primary_pi_role, source: :identity

    has_many :sparc_requests
    has_many :specimen_records

    has_many :project_roles
    has_many :service_requests
    has_many :sub_service_requests

    validates_presence_of :short_title, :title, :funding_status, :start_date, :end_date, :next_ssr_id
    validates_presence_of :funding_source, if: Proc.new{ |p| p.funded? }
    validates_presence_of :potential_funding_source, if: Proc.new{ |p| !p.funded? }

    accepts_nested_attributes_for :primary_pi_role

    before_validation :default_values

    def identifier
      "#{self.id} - #{self.short_title}"
    end

    def funded?
      self.funding_status == 'funded'
    end

    private

    def default_values
      self.next_ssr_id ||= 1
    end
  end
end
