source 'http://rubygems.org'

gem 'rails', '3.0.3'
gem 'devise'
gem 'mysql2'
gem 'bluecloth'
gem "will_paginate", "~> 3.0.pre2"
gem 'hirb'
gem 'haml', '~> 3.0.21'
gem 'nokogiri'
gem 'hoptoad_notifier'
gem 'aws-s3', :require => 'aws/s3'
# gem "nifty-generators"

gem "escape_utils" # annoying UTF-8 warning with ruby 1.9.2

# gem 'hpricot' # only for generating devise views
# gem 'ruby_parser' # only for generating devise views

group :development do
  gem "capistrano"
  gem "capistrano-ext"
  gem "capistrano_colors", :require => false

  platforms :mri_19 do
    gem "mongrel", "~> 1.2.0.pre2"
  end
end

group :development, :test, :cucumber do
  gem "rspec-rails", '2.1.0'
end

group :test, :cucumber do
  gem "database_cleaner"
  gem 'cucumber', '0.9.4'
  gem 'cucumber-rails', '0.3.2'
  gem "factory_girl_rails"
  gem "capybara"
  gem "nokogiri"
  gem "shoulda"
  # gem "fakeweb"
  # gem "timecop"
  # gem "treetop"
  # gem "launchy"
end
