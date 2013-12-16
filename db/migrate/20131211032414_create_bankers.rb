class CreateBankers < ActiveRecord::Migration
  def change
    create_table :bankers do |t|
      t.integer :simple_success

      t.timestamps
    end
  end
end
