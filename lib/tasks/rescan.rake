namespace :rescan do
  task start: :environment do
    RescanRunner.instance.schedule
  end
end
