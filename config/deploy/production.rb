server 'lbb.musc.edu', user: 'capistrano', roles: %w{app db web}

set :deploy_to, '/var/www/rails/sparc-biobank'
set :branch, 'production'
set :rails_env, 'production'
set :rvm_ruby_version, '2.4.2@sparc-biobank --create'
set :passenger_restart_with_touch, true

set :default_env, {
  'LD_LIBRARY_PATH' => '/usr/lib/oracle/18.3/client64/lib',
  'CXX' => '/opt/rh/devtoolset-2/root/usr/bin/gcc'
}
