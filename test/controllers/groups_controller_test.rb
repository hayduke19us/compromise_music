require "test_helper"

class GroupsControllerTest < ActionController::TestCase

  test "if group is saved redirect to root path" do
    user = users(:martha)
    assert_difference('Group.count', 1) do
      post :create, name: "boat's crew", user_id: user.id
    end
    group = assigns(:group)

    # I can't remember for the life of me why i have removed the apostrophe
    # will investigate later

    assert_equal "boats crew", group.name
    assert_redirected_to root_path
  end

  test "if group not saved redirect to new user group pat" do
    user = users(:martha)
    post :create, name: nil, user_id: user.id
    assert_redirected_to new_user_group_path(user)
  end

  test "if group is destroyed redirect to root_path" do
    assert_difference('Group.count', -1) do
      group = groups(:marthas_friends)
      delete :destroy, format: 'js', id: group.id
    end
    assert assigns(:response)
    assert_response :success
  end

end
