class Banker < ActiveRecord::Base
  validates :user_id, :simple_success, :presence => :true
  validates_uniqueness_of :user_id
 
  def self.new_account(user_id, simple_success=0)
    banker = Banker.new(user_id: user_id, simple_success: simple_success)
    banker.save 
  end
end
