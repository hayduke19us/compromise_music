class RemoveTracksFromPlaylist < ActiveRecord::Migration
  def change
    remove_column :playlists, :tracks, :string
  end
end
