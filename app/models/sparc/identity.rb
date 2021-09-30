require 'sparc/directory'

module SPARC
  class Identity < SPARC::Base
    has_many :project_roles, dependent: :destroy
    has_many :service_providers, dependent: :destroy
    has_many :labs

    validates_presence_of :last_name, :first_name, :email
    validates_format_of :email, with: DataTypeValidator::EMAIL_REGEXP, allow_blank: true, if: :email_changed?

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

    def suggestion_value
      Setting.get_value('use_ldap') && Setting.get_value('lazy_load_ldap') ? self.ldap_uid : self.id
    end

    def full_name
      "#{first_name.try(:humanize)} #{last_name.try(:humanize)}".strip
    end

    def display_name
      "#{first_name.try(:humanize)} #{last_name.try(:humanize)} (#{email})".strip
    end
  end
end
