source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'ar-octopus'
gem 'bootstrap', '~> 4.1.1'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-table-rails'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'dotenv-rails'
gem 'faker'
gem 'font-awesome-rails'
gem 'foreman', '~> 0.84.0'
gem 'haml'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'letter_opener'
gem 'mini_racer', platforms: :ruby
gem 'mysql2'
gem 'net-ldap', '~> 0.16.0'
gem 'pry'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.3'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 3.0', '>= 3.0.2'

# adding oracle for i2b2 access
gem 'activerecord-oracle_enhanced-adapter', '~> 1.8.0'
gem 'ruby-oci8'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end
