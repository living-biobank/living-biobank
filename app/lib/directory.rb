require 'net/ldap'

class Directory
  mattr_accessor :ldap_host
  mattr_accessor :ldap_port
  mattr_accessor :ldap_base
  mattr_accessor :ldap_encryption
  mattr_accessor :domain
  mattr_accessor :ldap_uid
  mattr_accessor :ldap_last_name
  mattr_accessor :ldap_first_name
  mattr_accessor :ldap_email
  mattr_accessor :ldap_auth_username
  mattr_accessor :ldap_auth_password
  mattr_accessor :ldap_filter

  # Load the YAML file for ldap configuration and set constants
  if File.exists?(Rails.root.join('config', 'ldap.yml'))
    begin
      ldap_config         ||= YAML.load_file(Rails.root.join('config', 'ldap.yml'))[Rails.env]
      @@ldap_host           = ldap_config['ldap_host']
      @@ldap_port           = ldap_config['ldap_port']
      @@ldap_base           = ldap_config['ldap_base']
      @@ldap_encryption     = ldap_config['ldap_encryption'].to_sym
      @@domain              = ldap_config['ldap_domain']
      @@ldap_uid            = ldap_config['ldap_uid']
      @@ldap_last_name      = ldap_config['ldap_last_name']
      @@ldap_first_name     = ldap_config['ldap_first_name']
      @@ldap_email          = ldap_config['ldap_email']
      @@ldap_auth_username  = ldap_config['ldap_auth_username']
      @@ldap_auth_password  = ldap_config['ldap_auth_password']
      @@ldap_filter         = ldap_config['ldap_filter']
    rescue
      raise "Your LDAP configuration is invalid for #{Rails.env} environment. Check config/ldap.yml"
    end
  else
    raise "config/ldap.yml not found, see config/ldap.yml.example"
  end

  def self.get_ldap_filter(term, fields)
    search_terms = term.strip.split

    if @@ldap_filter
      search_terms.each{ |t| @@ldap_filter.gsub('#{t}', t) }
    else
      fields.map do |f|
        search_terms.map{ |t| Net::LDAP::Filter.contains(f, t) }
      end.flatten.inject(:|)
    end
  end

  # Searches LDAP only for the given search string.  Returns an array of
  # Net::LDAP::Entry.
  def self.search_ldap(term)
    # Set the search fields from the constants provided
    fields  = [@@ldap_uid, @@ldap_last_name, @@ldap_first_name, @@ldap_email]
    results = nil

    # query ldap and create new identities
    begin
      ldap = Net::LDAP.new(
        host: @@ldap_host, port: @@ldap_port,
        base: @@ldap_base, encryption: @@ldap_encryption
      )

      ldap.auth(@@ldap_auth_username, @@ldap_auth_password) if @@ldap_auth_username && @@ldap_auth_password

      results = ldap.search(attributes: fields, filter: self.get_ldap_filter(term, fields))

      Rails.logger.info ldap.get_operation_result unless results
    rescue => e
      Rails.logger.info '#'*100
      Rails.logger.info "#{e.message} (#{e.class})"
      Rails.logger.info '#'*100
    end

    results
  end
end
