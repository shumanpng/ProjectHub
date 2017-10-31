require 'test_helper'

class ActiveUsersControllerTest < ActionController::TestCase
  setup do
    @active_user = active_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:active_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create active_user" do
    assert_difference('ActiveUser.count') do
      post :create, active_user: { token: @active_user.token, user_id: @active_user.user_id }
    end

    assert_redirected_to active_user_path(assigns(:active_user))
  end

  test "should show active_user" do
    get :show, id: @active_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @active_user
    assert_response :success
  end

  test "should update active_user" do
    patch :update, id: @active_user, active_user: { token: @active_user.token, user_id: @active_user.user_id }
    assert_redirected_to active_user_path(assigns(:active_user))
  end

  test "should destroy active_user" do
    assert_difference('ActiveUser.count', -1) do
      delete :destroy, id: @active_user
    end

    assert_redirected_to active_users_path
  end
end
