require 'cucumber/rails'

Capybara.default_selector = :css

ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::Database.javascript_strategy = :truncation

I18n.backend.reload!
FactoryGirl.reload
