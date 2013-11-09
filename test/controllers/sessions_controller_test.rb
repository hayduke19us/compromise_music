require "test_helper"

class SessionsControllerTest < ActionController::TestCase

  test "get index view" do
    get :index
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
