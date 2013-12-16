class AddPlaylistKeyToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :playlist_key, :string
  end
end
