source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Keep this low enough until https://github.com/rack/rack/issues/1619 is fixed
gem 'rack', '~> 2.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.2.3', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use ActiveModelSerializer for serializing to JSON
gem 'active_model_serializers', '~> 0.10'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1'

gem 'delayed_job_active_record', '~> 4.1'

gem 'easytag', '~> 1.0'
# taglib-ruby released version 1.0, but easytag isn't updated (yet) to work with it.
gem 'taglib-ruby', '< 1.0'

gem 'has_scope', '~> 0.7'
gem 'pundit', '~> 2.1'
gem 'will_paginate', '~> 3.3'

# Use ActiveStorage variant
gem 'image_processing', '~> 1.10.3'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.6', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1'

group :test do
  gem 'codecov', '~> 0.1.16', require: false
  gem 'mocha', '~> 1.11.2', require: false
  gem 'simplecov', '~> 0.18', require: false
end

group :development, :test do
  gem 'factory_bot_rails', '~> 5.2'
  gem 'faker', '~> 2.11'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'annotate', '~> 3.1'

  gem 'rubocop-rails', '~> 2.5'

  gem 'listen', '>= 3.1.5', '< 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
