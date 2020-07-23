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

  # Searches LDAP and the database for a given search string (can be
  # ldap_uid, last_name, first_name, email).  If a user is found in
  # LDAP that is not in the database, an Identity is created for it.
  # Returns an array of Identities that match the query.
  def self.search(term)
    ldap_results  = self.search_ldap(term)
    db_results    = self.search_database(term)
    self.create_or_update_database_from_ldap(ldap_results, db_results)
    # Finally, search the database a second time and return the results.
    # If there were no new users created, then this should return
    # the same as the original call to search_database().
    return self.search_database(term)
  end

  # Searches the database only for a given search string.  Returns an
  # array of Identities.
  def self.search_database(term)
    User.search(term)
  end

  # Searches LDAP only for the given search string.  Returns an array of
  # Net::LDAP::Entry.
  def self.search_ldap(term)
    # Set the search fields from the constants provided
    fields  = [@@ldap_uid, @@ldap_last_name, @@ldap_first_name, @@ldap_email]
    results = nil

    # query ldap and create new users
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

  def self.find_or_create(ldap_uid)
    user = User.find_by_net_id(ldap_uid)
    return user if user
    # search the ldap using unid, create the record in database, and then return it
    unless m = /(.*)@#{@@domain}/.match(ldap_uid)
      ldap_uid.concat("@#{@@domain}")
      m = /(.*)@#{@@domain}/.match(ldap_uid)
    end
    ldap_results = self.search_ldap(m[1])
    self.create_or_update_database_from_ldap(ldap_results, [])
    Identity.find_by_net_id(ldap_uid)
  end

  # Create or update the database based on what was returned from ldap.
  # ldap_results should be an array as would be returned from
  # search_ldap.  db_results should be an array as would be returned
  # from search_database.
  def self.create_or_update_database_from_ldap(ldap_results, db_results)
    # no need to proceed if ldap_results == nil or []
    return if ldap_results.blank?
    # This is an optimization so we only have to go to the database once
    users = { }

    db_results.each do |user|
      users[user.net_id] = user
    end

    ldap_results.each do |r|
      begin
        uid         = "#{r[@@ldap_uid].try(:first).try(:downcase)}@#{@@domain}"
        email       = r[@@ldap_email].try(:first)
        first_name  = r[@@ldap_first_name].try(:first)
        last_name   = r[@@ldap_last_name].try(:first)

        # Check to see if the user is already in the database
        if (user = users[uid]) or (user = User.find_by_net_id(uid)) then
          # Do we need to update any of the fields?  Has someone's last
          # name changed due to getting married, etc.?
          if user.email != email or user.last_name != last_name or user.first_name != first_name then
            user.update_attributes!(
              email:      email,
              first_name: first_name,
              last_name:  last_name
            )
          end
        else
          # If it is not in the database already, then add it.
          #
          # Use what we got from ldap for first/last name.  We don't use
          # String#capitalize here because it does not work for names
          # like "McHenry".
          #
          # since we auto create we need to set a random password and auto
          # confirm the addition so that the user has immediate access
          User.create!(
            first_name: first_name,
            last_name:  last_name,
            email:      email,
            net_id:     uid,
            password:   Devise.friendly_token[0,20]
          )
        end
      rescue ActiveRecord::ActiveRecordError => e
        # TODO: rescuing this exception means that an email will not get
        # sent.  This may or may not be the behavior that we want, but
        # it is the existing behavior.
        Rails.logger.info '#'*100
        Rails.logger.info "#{e.message} (#{e.class})"
        Rails.logger.info e.backtrace.first(20)
        Rails.logger.info '#'*100
      end
    end
  end
end
