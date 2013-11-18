require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "if user is empty it is invalid" do  
    user = User.new
    refute user.valid?, "user lacks validations"
  end 
  
  test "if user object is populated it is valid" do
    user = users(:martha)
    assert user.valid?, "user is missing an attribute"   
  end

  test "user has an association with playlist" do
    user = users(:martha)
    assert_equal 1, user.playlists.count  
  end

  test "when user is deleted users's playlists are deleted" do
    user = users(:martha)
    playlist = Playlist.all
    assert_equal 2, playlist.count, "all playlist count '2'"
    user.destroy
    assert_equal 1, playlist.count, "playlist count after user delete '1'"
  end
  
  test "user has an association with friendships" do
    user = users(:martha)
    assert_equal 1, user.friendships.count
  end
  
  test "users have friends through a friendship association" do
   user = users(:martha)
   assert_equal 1, user.friends.count
  end

  test "when user is deleted users's friendships are deleted" do
    user = users(:martha)
    friendships = Friendship.all
    assert_equal 1, friendships.count, "all friendships count '1'"
    user.destroy
    assert_equal 0, friendships.count, "friendship count after user delete '0'"
  end
  
  test "user has an association with tracks" do
    user = users(:martha)
    assert_equal 1, user.tracks.count
  end
  
  test "user has an association with votes" do
   user = users(:martha)
   refute_nil user.votes
  end
  
  test "user can vote on a track" do
    user = users(:martha)
    track = tracks(:ramona)
    user_track = user.tracks.first
    assert_equal 1, user_track.votes.count
  end

end
