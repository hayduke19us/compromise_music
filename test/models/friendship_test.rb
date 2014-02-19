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

end
