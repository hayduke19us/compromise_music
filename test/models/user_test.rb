require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new
  end
  def
    @user.destroy!
  end
  
  test "users must be valid" do
    refute @user.valid?, "user lacks validations"

    @user = users(:martha)
    assert @user.valid?, "user is missing an attribute"   
  end

  test "user has an association to playlist" do
    @user = users(:martha)
    assert_equal 1, @user.playlists.count  
  end

  test "when user is deleted all associations are deleted" do
    user = users(:martha)
    assert_equal 1, user.playlists.count, "martha's playlist count '1'"
    playlist = Playlist.all
    assert_equal 2, playlist.count, "all playlist count '2'"
    user.destroy
    assert_equal 1, playlist.count, "playlist count after user delete '1'"
  end
end
