class AddAlbumToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :album, :string
  end
end
