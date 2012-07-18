source 'http://rubygems.org'

gem 'rails', '>= 3.2.0rc1'

gem 'jquery-rails'
gem 'capistrano'
gem 'paranoia'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'paperclip'
gem 'aws-s3'
gem 'resque'
gem 'redis'
gem 'haml'
gem 'activesupport'

group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass', '~> 2.0.4.0'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'sqlite3', require: 'sqlite3'
  gem 'bullet'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'awesome_print'
end

group :production do
  gem 'pg'
  gem 'thin'
end

group :test do
  gem 'rspec-rails', '~> 2.4'
  gem 'guard'
  gem 'guard-rspec'
  gem 'spork'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'ffaker'
end

group :test, :development do
  gem 'factory_girl'
  gem 'capybara'
end
