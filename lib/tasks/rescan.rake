namespace :rescan do
  task start: :environment do
    rescan = RescanRunner.first || RescanRunner.create
    rescan.delay(queue: :rescans).run
  end
end
