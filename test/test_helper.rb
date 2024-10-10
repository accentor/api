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

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include ActiveJob::TestHelper

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
  attr_accessor :credentials

  def sign_in_as(user)
    auth_token = create(:auth_token, user:)
    self.credentials = { 'x-device-id': auth_token.device_id, 'x-secret': auth_token.secret }
  end

  def sign_out
    self.credentials = {}
  end

  def merge_args(args)
    args ||= {}
    args[:headers] = args[:headers] || {}
    creds = credentials || {}
    { as: :json }.merge(args || {}).merge(headers: creds.merge(args[:headers]))
  end

  def get(path, **args)
    process(:get, path, **merge_args(args))
  end

  def post(path, **args)
    process(:post, path, **merge_args(args))
  end

  def patch(path, **args)
    process(:patch, path, **merge_args(args))
  end

  def put(path, **args)
    process(:put, path, **merge_args(args))
  end

  def delete(path, **args)
    process(:delete, path, **merge_args(args))
  end

  def head(path, **args)
    process(:head, path, **merge_args(args))
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
