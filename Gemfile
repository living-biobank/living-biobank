source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'actiontext', github: 'kobaltz/actiontext', branch: 'archive', require: 'action_text'
gem 'acts_as_list'
gem 'acts_as_paranoid'
gem 'babel-transpiler'
gem 'bootsnap'
gem 'capistrano', '~> 3.12'
gem 'capistrano-bundler', require: false
gem 'capistrano-rvm', require: false
gem 'capistrano-rails', require: false
gem 'capistrano-passenger', require: false
gem 'capistrano3-delayed-job', '~> 1.7'
gem 'coffee-rails', '~> 4.2'
gem 'delayed_job_active_record'
gem 'delayed_job'
gem 'devise'
gem 'dotenv-rails'
gem 'exception_notification'
gem 'font-awesome-sass'
gem 'haml'
gem 'httparty'
gem 'i18n-js'
gem 'image_processing'
gem 'jbuilder', '~> 2.10'
gem 'letter_opener'
gem 'mysql2'
gem 'nested_form_fields'
gem 'net-ldap', '~> 0.16.0'
gem 'omniauth'
gem 'omniauth-shibboleth'
gem 'omniauth-rails_csrf_protection'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
gem 'request_store'
gem 'sassc-rails'
gem 'simple_hl7'
gem 'sprockets', '~> 4.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.x'
gem 'whenever'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'

# adding oracle for i2b2 access
gem 'activerecord-oracle_enhanced-adapter', '~> 5.2.0'
gem 'ruby-oci8'

# adding sqlserver for ACT Shrine access
gem 'tiny_tds'
gem 'activerecord-sqlserver-adapter'


gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'webdrivers', '~> 4.0'
end
