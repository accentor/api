source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.2.3', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 6.4'
# Use ActiveModelSerializer for serializing to JSON
gem 'active_model_serializers', '~> 0.10'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

# Use GoodJob as our Active Job queue adapter
gem 'good_job', '~> 4.2'

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
  gem 'codecov', '~> 0.6.0', require: false
  gem 'mocha', '~> 2.4.5', require: false
  gem 'simplecov', '~> 0.21', require: false
end

group :development, :test do
  gem 'debug', '~> 1.9'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
end

group :development do
  gem 'annotate', '~> 3.2', require: false # Remove workaround in lib/tasks/annotate.rb when https://github.com/ctran/annotate_models/issues/696 is fixed
  gem 'rubocop', '~> 1.65', require: false
  gem 'rubocop-factory_bot', '~> 2.26', require: false
  gem 'rubocop-minitest', '~> 0.35.1', require: false
  gem 'rubocop-rails', '~> 2.26', require: false
  gem 'ruby-lsp', '~> 0.17.17', require: false

  gem 'brakeman', require: false
end
