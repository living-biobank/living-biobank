source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'coffee-rails', '~> 4.2'
gem 'delayed_job_active_record'
gem 'devise'
gem 'dotenv-rails'
gem 'font-awesome-sass'
gem 'foreman', '~> 0.84.0'
gem 'haml'
gem 'httparty'
gem 'i18n-js'
gem 'jbuilder', '~> 2.5'
gem 'letter_opener'
#gem 'mini_racer', platforms: :ruby
gem 'mysql2'
gem 'nested_form_fields'
gem 'net-ldap', '~> 0.16.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.1.3'
gem 'request_store'
gem 'sassc-rails'
gem 'simple_hl7'
gem 'therubyracer'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 3.5'
gem 'whenever'

# adding oracle for i2b2 access
gem 'activerecord-oracle_enhanced-adapter', '~> 1.8.0'
gem 'ruby-oci8'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '=3.11.0'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
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
  gem 'webdrivers', '~> 3.0'
end
