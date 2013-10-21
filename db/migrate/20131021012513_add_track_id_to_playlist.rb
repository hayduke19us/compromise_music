class AddTrackIdToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :track_id, :string
  end
end
