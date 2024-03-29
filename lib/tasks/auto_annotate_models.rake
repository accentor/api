# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
if Rails.env.development?
  require 'annotate'
  # rubocop:disable Rails/RakeEnvironment
  # We don't depend on the rails environment here (we don't use models/controllers/whatever)
  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the
    # same name.
    Annotate.set_defaults(
      'additional_file_patterns' => [],
      'routes' => 'true',
      'models' => 'true',
      'position_in_routes' => 'before',
      'position_in_class' => 'before',
      'position_in_test' => 'before',
      'position_in_fixture' => 'before',
      'position_in_factory' => 'before',
      'position_in_serializer' => 'before',
      'show_foreign_keys' => 'false',
      'show_complete_foreign_keys' => 'false',
      'show_indexes' => 'false',
      'simple_indexes' => 'false',
      'model_dir' => 'app/models',
      'root_dir' => '',
      'include_version' => 'false',
      'require' => '',
      'exclude_tests' => 'false',
      'exclude_fixtures' => 'false',
      'exclude_factories' => 'false',
      'exclude_serializers' => 'false',
      'exclude_scaffolds' => 'true',
      'exclude_controllers' => 'true',
      'exclude_helpers' => 'true',
      'exclude_sti_subclasses' => 'false',
      'ignore_model_sub_dir' => 'false',
      'ignore_columns' => nil,
      'ignore_routes' => nil,
      'ignore_unknown_models' => 'false',
      'hide_limit_column_types' => 'integer,bigint,boolean',
      'hide_default_column_types' => 'json,jsonb,hstore',
      'skip_on_db_migrate' => 'false',
      'format_bare' => 'true',
      'format_rdoc' => 'false',
      'format_markdown' => 'false',
      'sort' => 'false',
      'force' => 'false',
      'frozen' => 'false',
      'classified_sort' => 'true',
      'trace' => 'false',
      'wrapper_open' => nil,
      'wrapper_close' => nil,
      'with_comment' => 'true'
    )
  end

  # We manually fix the routes command until https://github.com/ctran/annotate_models/pull/843 is merged
  task :routes do
    require 'rails/commands/routes/routes_command'
    Rails.application.require_environment!
    cmd = Rails::Command::RoutesCommand.new
    cmd.perform
  end

  # rubocop:enable Rails/RakeEnvironment

  Annotate.load_tasks
end
