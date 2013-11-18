class CreateGrouplists < ActiveRecord::Migration
  def change
    create_table :grouplists do |t|
      t.integer :group_id
      t.integer :playlist_id

      t.timestamps
    end
  end
end
