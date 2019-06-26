lock "3.11.0"

set :application, "biobank"
set :repo_url, "git@sparc_biobank:HSSC/sparc-biobank.git"

append :linked_files,
  'config/database.yml', 'config/secrets.yml', 'config/ldap.yml',
  'config/i2b2_database.yml', 'config/sparc_request_database.yml',
  '.ruby-version', '.ruby-gemset', '.env'

append :linked_dirs,
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'bundle', 'node_modules'
