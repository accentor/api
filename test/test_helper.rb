require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  add_filter 'vendor'
  add_group 'Policies', 'app/policies'
  add_group 'Serializers', 'app/serializers'
end

if ENV['CI'].present?
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

module AudioFileTestHelper
  def install_audio_file_convert_stub(implementation = nil)
    AudioFile.alias_method :old_convert, :convert
    AudioFile.define_method :convert, implementation || ->(_codec_conversion, out_file_name) { FileUtils.cp full_path, out_file_name }
  end

  def uninstall_audio_file_convert_stub
    AudioFile.alias_method :convert, :old_convert
  end

  def with_stubbed_audio_file_convert(implementation = nil)
    install_audio_file_convert_stub implementation
    yield
  ensure
    uninstall_audio_file_convert_stub
  end
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include ActiveJob::TestHelper
  include AudioFileTestHelper

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    # Make sure each worker has its own base path for conversion testing.
    # Sadly we can't do this in config/environment/test.rb :(
    # So instead, we do the following crime:
    old_base_path = TranscodedItem::BASE_PATH
    TranscodedItem.send :remove_const, :BASE_PATH
    TranscodedItem.const_set :BASE_PATH, File.join(old_base_path, worker.to_s)

    SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
  end

  parallelize_teardown do |_worker|
    SimpleCov.result
  end

  teardown do
    Faker::UniqueGenerator.clear
  end
end

module SignInHelper
  attr_accessor :api_token

  def sign_in_as(user)
    self.api_token = create(:auth_token, user:).generate_token_for(:api)
  end

  def sign_out
    self.api_token = nil
  end

  def merge_args(**args)
    headers = { Authorization: "Bearer #{api_token}" }.merge(args.fetch(:headers, {}))
    { as: :json }.merge(args).merge(headers:)
  end

  def get(path, **)
    process(:get, path, **merge_args(**))
  end

  def post(path, **)
    process(:post, path, **merge_args(**))
  end

  def patch(path, **)
    process(:patch, path, **merge_args(**))
  end

  def put(path, **)
    process(:put, path, **merge_args(**))
  end

  def delete(path, **)
    process(:delete, path, **merge_args(**))
  end

  def head(path, **)
    process(:head, path, **merge_args(**))
  end
end

module EtagHelper
  def construct_etag(query, page: nil, per_page: nil)
    cache_key = ActiveSupport::Cache.expand_cache_key([query.cache_key_with_version, page, per_page].compact)
    "W/\"#{ActiveSupport::Digest.hexdigest(cache_key)}\""
  end
end

class ActionDispatch::IntegrationTest
  include EtagHelper
  include SignInHelper
end
