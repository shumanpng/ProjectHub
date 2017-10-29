require 'test_helper'

class GroupMembershipsControllerTest < ActionController::TestCase
  setup do
    @group_membership = group_memberships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:group_memberships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group_membership" do
    assert_difference('GroupMembership.count') do
      post :create, group_membership: { group_id: @group_membership.group_id, is_admin: @group_membership.is_admin, user_id: @group_membership.user_id }
    end

    assert_redirected_to group_membership_path(assigns(:group_membership))
  end

  test "should show group_membership" do
    get :show, id: @group_membership
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group_membership
    assert_response :success
  end

  test "should update group_membership" do
    patch :update, id: @group_membership, group_membership: { group_id: @group_membership.group_id, is_admin: @group_membership.is_admin, user_id: @group_membership.user_id }
    assert_redirected_to group_membership_path(assigns(:group_membership))
  end

  test "should destroy group_membership" do
    assert_difference('GroupMembership.count', -1) do
      delete :destroy, id: @group_membership
    end

    assert_redirected_to group_memberships_path
  end
end
