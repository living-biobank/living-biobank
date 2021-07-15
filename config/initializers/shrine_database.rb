SHRINE_DB = YAML::load(ERB.new(File.read(Rails.root.join('config', 'shrine_database.yml'))).result)[Rails.env.to_s]
