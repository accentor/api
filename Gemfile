source 'https://rubygems.org'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2.1'
# Keep this low enough until https://github.com/rack/rack/issues/1619 is fixed
gem 'rack', '~> 2.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.2.3', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.13'

gem 'delayed_job_active_record', '~> 4.1.4'

gem 'easytag', '~> 1.0.0'
# taglib-ruby released version 1.0, but easytag isn't updated (yet) to work with it.
gem 'taglib-ruby', '< 1.0'

gem 'has_scope', '~> 0.7.2'
gem 'pundit', '~> 2.1.0'
gem 'will_paginate', '~> 3.1.8'

# Use ActiveStorage variant
gem 'image_processing', '~> 1.10.3'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.6', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0.6'

group :test do
  gem 'simplecov', '~> 0.16.1'
end

group :development, :test do
  gem 'factory_bot_rails', '~> 5.0.2'
  gem 'faker', '~> 1.9.6'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'annotate', '~> 2.7.5'

  gem 'listen', '>= 3.1.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1.0'
  gem 'spring-watcher-listen', '~> 2.0.1'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
