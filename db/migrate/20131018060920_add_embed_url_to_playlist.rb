class AddEmbedUrlToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :embedUrl, :string
  end
end
