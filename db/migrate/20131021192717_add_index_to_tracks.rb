class AddIndexToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :index, :integer
  end
end
