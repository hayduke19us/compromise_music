require "test_helper"

class FriendshipTest < ActiveSupport::TestCase

  test "empty friendships are invalid" do
    friendship = Friendship.new
    refute friendship.valid?, "friendship is missing validations"
  end

  test "populated friendships are valid" do
    friendship = friendships(:short_friendship)
    assert friendship.valid?
  end

  test "friendships must be unique" do
    tom = users(:tom)
    martha = users(:martha)
    dup_friendship = Friendship.new(user_id: martha.id, friend_id: tom.id)
    refute dup_friendship.valid?
  end

  test "friendship needs a user_id" do
    friendship = friendships(:short_friendship)
    friendship.user_id = nil
    refute friendship.valid?
  end

   test "friendship needs a friend_id" do
    friendship = friendships(:short_friendship)
    friendship.friend_id = nil
    refute friendship.valid?
  end

   test "friendships have a friend" do
     friendship = friendships(:short_friendship)
     tom = users(:tom)
     assert_equal friendship.friend, tom
   end

   test "when friendship is deleted the associated groupships are deleted" do
     martha = users(:martha)
     friendship = friendships(:short_friendship)
     friendship.delete_associated_groupships

     martha.groups.each do |g|
       assert_equal 0, g.groupships.where(friend_id: friendship.friend).count
     end
   end

   test "when friendship is deleted the collaborated groups your apart of are deleted"  do
     martha = users(:martha) 
     friendship = friendships(:short_friendship)
     friendship.delete_collaborated_groupships

     assert_equal 0, Groupship.where(friend_id: martha).count
   end

end
