lock "3.11.0"

set :application, "biobank"
set :repo_url, "git@sparc_biobank:HSSC/sparc-biobank.git"

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/i2b2_database.yml',
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
