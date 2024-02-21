# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.1.1'
gem 'puma', '>= 5.0'

gem 'jbuilder'

# gem "redis", ">= 4.0.1"
# gem "kredis"

gem 'devise'
gem 'devise-jwt'

gem 'image_processing'
gem 'rack-cors'

gem 'pundit'
gem 'acts_as_votable'
gem 'counter_culture'
gem 'active_storage_validations'
gem 'pagy'

gem 'pg', '~> 1.1'

gem 'acts-as-taggable-on'
gem 'sendgrid-actionmailer'
gem 'googleauth'
gem 'redis'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'bootsnap', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'figaro'
  gem 'bullet'
  gem 'dotenv-rails'
  gem 'annotate'
  gem 'letter_opener'
  gem 'faker'
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
end

group :production do
  gem 'aws-sdk-s3', require: false
end
