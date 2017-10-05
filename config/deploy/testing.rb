server 'bmic-sparc-dev.obis.musc.edu', user: 'capistrano', roles: %w{app db web}

set :deploy_to, '/var/www/rails/sparc-biobank'
set :branch, 'testing'
set :rails_env, 'testing'
set :rvm_ruby_version, '2.4.1@biobank --create'
set :passenger_restart_with_touch, true

