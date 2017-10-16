require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LdapAuthenticatable < Authenticatable
      def authenticate!
        if params[:user]
          ldap_config   ||= YAML.load_file(Rails.root.join('config', 'ldap.yml'))[Rails.env]
          ldap = Net::LDAP.new(host: ldap_config['ldap_host'],
                               port: ldap_config['ldap_port'],
                               encryption: ldap_config['ldap_encryption'],
                               base: ldap_config['ldap_base']
                              )
          ldap.auth "uid=#{login},ou=people,dc=musc,dc=edu", password
          if ldap.bind
            pwd = Devise.friendly_token
            user = User.create_with(password: pwd, password_confirmation: pwd, email: Directory.search_ldap(login).first[:mail].first).find_or_create_by(net_id: "#{login}@musc.edu")
            success!(user)
          else
            fail(:invalid_login)
          end
        end
      end

      def login
        params[:user][:login]
      end

      def password
        params[:user][:password]
      end
    end
  end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
