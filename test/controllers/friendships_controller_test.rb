require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  test "when friendship has no friend it's redirected to root" do
    user = users(:martha)
    post :create, user: user, friend: ""
    assert_redirected_to root_path
  end

  test "if friend params is a string it's redirected to root" do
    user = users(:martha)
    post :create, user: user, friend: "friend"
    assert_redirected_to root_path 
  end

  test "if friendship already exists it's redirected to root" do
    user = users(:martha)
    friend = users(:tom)
    post :create, user: user, friend: friend
    assert_redirected_to root_path
  end

end
