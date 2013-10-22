class RemoveTrackIdFromPlaylist < ActiveRecord::Migration
  def change
    remove_column :playlists, :track_id, :string
  end
end
