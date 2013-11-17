class AddSqlIndexToTracks < ActiveRecord::Migration
  def change
    add_index :tracks, :user_id
  end
end
