class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'
  validates :user_id, :friend_id, presence: true
  validates_uniqueness_of :user_id, scope: :friend_id
  validates_numericality_of :user_id, :friend_id,  only_integer: true

  def delete_associated_groupships
    transaction do
      groupships = Groupship.where(friend_id: self.friend)
      groupships.each {|groupship| groupship.destroy}
    end
  end

end
