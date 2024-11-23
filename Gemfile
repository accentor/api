source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.2.3', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 6.5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

# Use GoodJob as our Active Job queue adapter
gem 'good_job', '~> 4.4'

gem 'wahwah', '~> 1.6.6'

gem 'has_scope', '~> 0.8'
gem 'pundit', '~> 2.4'
gem 'will_paginate', '~> 4.0'

# Use ActiveStorage variant
gem 'image_processing', '~> 1.13.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 2.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :test do
  gem 'mocha', '~> 2.5.0', require: false
  gem 'simplecov', '~> 0.22', require: false
  gem 'simplecov-cobertura', '~> 2.1.0', require: false
end

group :development, :test do
  gem 'debug', '~> 1.9'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.5'
end

group :development do
  gem 'annotaterb', '~> 4.13', require: false
  gem 'rubocop', '~> 1.68', require: false
  gem 'rubocop-factory_bot', '~> 2.26', require: false
  gem 'rubocop-minitest', '~> 0.36.0', require: false
  gem 'rubocop-rails', '~> 2.27', require: false
  gem 'ruby-lsp', '~> 0.22.1', require: false

  gem 'brakeman', require: false
end
