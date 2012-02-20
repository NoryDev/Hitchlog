source 'http://rubygems.org'

gem 'rake', '0.9.2'

gem 'rails', '3.2.0'
gem 'sqlite3'
gem 'mysql2',  '>=0.3'

gem 'devise', '1.4.5'
gem 'rdiscount'
gem 'will_paginate', '~> 3.0.pre2'
gem 'nokogiri'
gem 'hoptoad_notifier'

# replacement for meta_search which isn't compatible with rails 3.1
gem 'ransack' 
gem 'geocoder'
gem 'paperclip'
gem 'jammit'
gem 'mongrel', '1.2.0.pre2'
gem 'json'
gem 'aws-s3', :require => 'aws/s3'
gem 'hpricot'
gem 'compass'
gem 'haml', '~> 3.1.4'
gem 'compass-colors'
gem 'fancy-buttons'
gem 'gravatar_image_tag'
gem 'escape_utils' # annoying UTF-8 warning with ruby 1.9.2
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'i18n_data'
gem 'friendly_id', '~> 3.2.1'
gem 'choices' # external settings in Rails app

# coffeescript
gem 'barista', '~> 1.0'

group :development do
  gem 'hirb'
  gem 'capistrano-ext'
  gem 'capistrano'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-spork'
  gem 'guard-bundler'
  gem 'livereload'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'launchy', '~> 2.0.5' # to use save_and_open_page
end

group :test do
  gem 'database_cleaner'
  gem 'spork', '0.9.0.rc9'
  gem 'factory_girl_rails'
  gem 'factory_girl_generator'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'faker'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
end
