server 'bmic-sparc-dev.obis.musc.edu/', user: 'capistrano', roles: %w{app db web}

set :deploy_to, '/var/www/rails/biobank'
set :branch, 'testing'
set :rails_env, 'production'
set :rvm_ruby_version, '2.4.1@biobank --create'
set :passenger_restart_with_touch, true

