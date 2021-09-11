namespace :rescan do
  task start: :environment do
    RescanRunner.instance.start_delayed
  end
end
