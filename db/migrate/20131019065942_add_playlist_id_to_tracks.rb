class AddPlaylistIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :playlist_id, :string
  end
end
