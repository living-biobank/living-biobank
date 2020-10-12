server 'bmic-sparc-dev.obis.musc.edu', user: 'capistrano', roles: %w{app db web}

set :deploy_to, '/var/www/rails/sparc-biobank'
set :branch, 'v1.1.1'
set :rails_env, 'testing'
set :rvm_ruby_version, '2.5.5@sparc-biobank --create'
set :passenger_restart_with_touch, true

set :default_env, {
  'LD_LIBRARY_PATH' => '/usr/lib/oracle/18.3/client64/lib',
  'CXX' => '/opt/rh/devtoolset-2/root/usr/bin/gcc'
}
