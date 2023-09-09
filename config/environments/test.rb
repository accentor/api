require 'active_support/core_ext/integer/time'

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test
  # locally, this probably isn't necessary. It's a good idea to do in a
  # continuous integration system, or in some way before deploying your code.
  config.eager_load = ENV['CI'].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Raise exception for all deprecations.
  config.active_support.deprecation = :raise

  # Raises error for missing translations.
  config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # For tests we want these settings to remain the same, regardless of the configuration in application.rb
  config.transcode_cache_expiry = -> { 1.day.ago }
  config.recalculate_content_length_if = ->(af) { af.length > 299 || af.track.created_at.after?(1.month.ago) }

  config.token_hash_rounds = 1
  config.ffmpeg_log_location = Rails.root.join('tmp/log/ffmpeg.log').to_s
  config.transcode_cache_path = Rails.root.join('tmp/storage/transcode_cache').to_s
end
