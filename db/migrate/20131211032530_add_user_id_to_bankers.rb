class AddUserIdToBankers < ActiveRecord::Migration
  def change
    add_column :bankers, :user_id, :integer
  end
end
