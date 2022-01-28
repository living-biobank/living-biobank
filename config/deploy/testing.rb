server 'bmic-sparc-d.mdc.musc.edu', user: 'capistrano', roles: %w{app db web}
set :repo_url, "git@living_biobank:living-biobank/living-biobank.git"

set :deploy_to, '/var/www/rails/living-biobank'
set :branch, 'testing'
set :rails_env, 'testing'
set :rvm_ruby_version, '2.5.5@living-biobank --create'
set :passenger_restart_with_touch, true

set :default_env, {
  'LD_LIBRARY_PATH' => '/usr/lib/oracle/19.9/client64/lib',
  'CXX' => '/opt/rh/devtoolset-3/root/usr/bin/gcc'
}
