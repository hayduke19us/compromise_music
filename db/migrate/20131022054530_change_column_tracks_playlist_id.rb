class ChangeColumnTracksPlaylistId < ActiveRecord::Migration
  def change
    change_column :tracks, :playlist_id, :integer
  end
end
