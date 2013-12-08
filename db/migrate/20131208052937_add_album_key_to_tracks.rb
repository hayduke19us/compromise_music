class AddAlbumKeyToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :album_key, :string
  end
end
