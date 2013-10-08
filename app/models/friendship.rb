class Friendship < ActiveRecord::Base
  belongs_to :user  
  belongs_to :friend, :class_name => 'User'
  validates_uniqueness_of :friend_id
  
  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end  
end
