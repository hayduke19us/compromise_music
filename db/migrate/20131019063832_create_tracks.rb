class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :key
      t.string :embedUrl

      t.timestamps
    end
  end
end
