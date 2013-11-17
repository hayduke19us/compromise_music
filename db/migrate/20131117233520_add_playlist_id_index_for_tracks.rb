class AddPlaylistIdIndexForTracks < ActiveRecord::Migration
  def change
   add_index :tracks, :playlist_id
  end
end
