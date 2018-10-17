I2B2_DB = YAML::load(ERB.new(File.read(Rails.root.join('config', 'i2b2_database.yml'))).result)[Rails.env.to_s]
