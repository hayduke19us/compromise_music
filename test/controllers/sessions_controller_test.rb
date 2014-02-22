require "test_helper"

class SessionsControllerTest < ActionController::TestCase

  test "get index view" do
    get :index
    assert_response :success
    assert_nil assigns(:user)
  end

  test "my playlist returns a sorted playlist" do
     playlist = playlists(:road_trip)
     post(:my_playlist, {playlist: playlist}) 
     assert_response :found
     refute_nil assigns(:sorted)
  end

  test "my group returns users group" do
    group = groups(:marthas_friends)
    post(:my_group, {group: group}) 
    refute_nil assigns(:group)
  end

  test "my friend returns users_except friends" do
    skip
  end

  test "should create session" do
    user = users(:martha)
    session[:user_id] = user.id
    refute_nil session.find(user_id: user.id)
    assert_equal 1, session.count
  end

  test "if session is destroyed  sessions.user_id is nil" do
    user = users(:martha)
    session[:user_id] = user.id
    session.destroy[user_id: user.id]
    assert_equal 0, session.count
  end

end
