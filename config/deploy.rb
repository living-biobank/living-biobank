lock "3.11.0"

set :application, "biobank"
set :repo_url, "git@sparc_biobank:HSSC/sparc-biobank.git"

append :linked_files,
  'config/database.yml', 'config/secrets.yml', 'config/ldap.yml',
  'config/i2b2_database.yml', 'config/sparc_request_database.yml',
  '.ruby-version', '.ruby-gemset', '.env'

append :linked_dirs,
  'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
  'public/packs', 'bundle', 'node_modules'

before 'deploy:assets:precompile', 'deploy:yarn_install'

namespace :deploy do
  desc 'Run rake yarn install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
