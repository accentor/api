namespace :rescan do
  task start: :environment do
    RescanRunner.schedule_all
  end
end
