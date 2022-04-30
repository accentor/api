class ChangeNullAlbumRelease < ActiveRecord::Migration[7.0]
  def change
    Album.where(release: nil).find_each do |a|
      # Skip validations, so this can't get stuck on other possible issues
      a.update_column(:release, Date.new(0))
    end

    change_column_null :albums, :release, false
    change_column_default :albums, :release, from: nil, to: Date.new(0)
  end
end
