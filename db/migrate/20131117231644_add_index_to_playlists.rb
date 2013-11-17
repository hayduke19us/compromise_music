class AddIndexToPlaylists < ActiveRecord::Migration
  def change
    add_index :playlists, :user_id
  end
end
