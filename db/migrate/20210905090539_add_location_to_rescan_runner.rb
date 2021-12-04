class AddLocationToRescanRunner < ActiveRecord::Migration[6.1]
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE rescan_runners")

    add_reference :rescan_runners, :location, null: false, foreign_key: true

    Location.find_each do |l|
      RescanRunner.create(finished_at: Date.new, location: l)
    end
  end
end
