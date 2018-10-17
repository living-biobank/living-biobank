SPARC_REQUEST_DB = YAML::load(ERB.new(File.read(Rails.root.join('config', 'sparc_request_database.yml'))).result)[Rails.env.to_s]
