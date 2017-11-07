require 'test_helper'

class GroupRequestsControllerTest < ActionController::TestCase
  setup do
    @group_request = group_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:group_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_request" do
    assert_difference('GroupRequest.count') do
      post :create, group_request: { group_id: @group_request.group_id, status: @group_request.status, user_id: @group_request.user_id }
    end

    assert_redirected_to group_request_path(assigns(:group_request))
  end

  test "should show group_request" do
    get :show, id: @group_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group_request
    assert_response :success
  end

  test "should update group_request" do
    patch :update, id: @group_request, group_request: { group_id: @group_request.group_id, status: @group_request.status, user_id: @group_request.user_id }
    assert_redirected_to group_request_path(assigns(:group_request))
  end

  test "should destroy group_request" do
    assert_difference('GroupRequest.count', -1) do
      delete :destroy, id: @group_request
    end

    assert_redirected_to group_requests_path
  end
end
