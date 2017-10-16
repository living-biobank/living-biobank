require 'net/ldap'

class Directory
  # Load the YAML file for ldap configuration and set constants
  begin
    ldap_config   ||= YAML.load_file(Rails.root.join('config', 'ldap.yml'))[Rails.env]
    LDAP_HOST       = ldap_config['ldap_host']
    LDAP_PORT       = ldap_config['ldap_port']
    LDAP_BASE       = ldap_config['ldap_base']
    LDAP_ENCRYPTION = ldap_config['ldap_encryption'].to_sym
    DOMAIN          = ldap_config['ldap_domain']
    LDAP_UID        = ldap_config['ldap_uid']
    LDAP_LAST_NAME  = ldap_config['ldap_last_name']
    LDAP_FIRST_NAME = ldap_config['ldap_first_name']
    LDAP_EMAIL      = ldap_config['ldap_email']
    LDAP_AUTH_USERNAME      = ldap_config['ldap_auth_username']
    LDAP_AUTH_PASSWORD      = ldap_config['ldap_auth_password']
    LDAP_FILTER      = ldap_config['ldap_filter']
  rescue
    raise "ldap.yml not found, see config/ldap.yml.example"
  end

  def self.get_ldap_filter(term, fields)
    search_terms = term.strip.split
    (LDAP_FILTER && LDAP_FILTER.gsub('#{term}', term)) || fields.map { |f| Net::LDAP::Filter.contains(f, term) }.inject(:|)
  end

  # Searches LDAP only for the given search string.  Returns an array of
  # Net::LDAP::Entry.
  def self.search_ldap(term)
    # Set the search fields from the constants provided
    fields = [LDAP_UID, LDAP_LAST_NAME, LDAP_FIRST_NAME, LDAP_EMAIL]

    # query ldap and create new identities
    begin
      ldap = Net::LDAP.new(
         host: LDAP_HOST,
         port: LDAP_PORT,
         base: LDAP_BASE,
         encryption: LDAP_ENCRYPTION)
      ldap.auth LDAP_AUTH_USERNAME, LDAP_AUTH_PASSWORD unless !LDAP_AUTH_USERNAME || !LDAP_AUTH_PASSWORD
      res = ldap.search(:attributes => fields, :filter => self.get_ldap_filter(term, fields))
      Rails.logger.info ldap.get_operation_result unless res
    rescue => e
      Rails.logger.info '#'*100
      Rails.logger.info "#{e.message} (#{e.class})"
      Rails.logger.info '#'*100
      res = nil
    end

    return res
  end
end
