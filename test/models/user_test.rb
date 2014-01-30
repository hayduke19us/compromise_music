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
    assert_equal 3, playlist.count, "all playlist count '2'"
    user.destroy
    assert_equal 2, playlist.count, "playlist count after user delete '1'"
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
    friendships = user.friendships
    assert_equal 1, friendships.count, "all friendships count '1'"
    user.destroy
    assert_equal 0, friendships.count, "friendship count after user delete '0'"
  end

  test "destroy_remaining_friendships! actually destroys friendships" do
    user = users(:martha)
    assert_not_nil Friendship.where(friend_id: user)
    user.destroy_remaining_friendships!
    assert_equal 0, Friendship.where(friend_id: user).count
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
    track = tracks(:imitosis)
    assert_equal 1, track.votes_for
    user = users(:martha)
    vote = Vote.create vote: true, voteable_type: "Track", voteable_id: track.id,
      voter_type: "User", voter_id: user.id
    track = Track.find track.id
    assert_equal 2, track.votes_for
  end
  
  test "user has one association with banker" do
    user = users(:martha)
    refute_nil user.banker, "martha should have an association with banker"
  end

  test "user can have 0 simple success points(integer of 0)" do
    user = users(:martha)
    assert_equal 0, user.banker.simple_success
  end

  test "collab_groups should return a collection of groups" do
    user = users(:martha)
    assert_equal 1, user.collab_groups.count
  end

  test "collab_playlist should return a collection of playlist" do
    user = users(:martha)
    assert_equal 1, user.collab_playlists.count
  end
end
