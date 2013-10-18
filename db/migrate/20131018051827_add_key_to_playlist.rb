class AddKeyToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :key, :string
  end
end
