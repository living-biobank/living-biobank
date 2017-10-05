lock "3.9.1"

set :application, "biobank"
set :repo_url, "git@sparc_biobank:HSSC/sparc-biobank.git"

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'config/shards.yml',
                                                 '.ruby-version',
                                                 '.ruby-gemset'
                                                )
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'public/system'
                                              )
