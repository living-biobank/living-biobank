lock "3.12.1"

set :application, "biobank"
set :repo_url, "git@sparc_biobank:living-biobank/living-biobank.git"
set :user, 'capistrano'
set :use_sudo, false

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/master.key',
                                                 'config/i2b2_database.yml',
                                                 'config/shrine_database.yml',
                                                 'config/sparc_request_database.yml',
                                                 'config/ldap.yml',
                                                 '.ruby-version',
                                                 '.ruby-gemset',
                                                 '.env'
                                                )
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'public/system'
                                              )

after "deploy:restart", "delayed_job:restart"
