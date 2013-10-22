class RemoveFriendIdFromPlaylist < ActiveRecord::Migration
  def change
    remove_column :playlists, :friend_id, :string
  end
end
