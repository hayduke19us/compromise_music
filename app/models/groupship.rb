class Groupship < ActiveRecord::Base
  validates :group_id, :friend_id, :presence => :true
  validates_uniqueness_of :group_id, scope: :friend_id
  belongs_to :group
  belongs_to :friend
end
