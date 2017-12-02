require 'test_helper'

class GroupMembershipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'membership must be associated with a group and a user' do
    gm = GroupMembership.new(:is_admin => false)
    assert(gm.invalid?, 'user_id & group_id are both nil')

    gm.user_id = 2
    assert(gm.invalid?, 'group_id is still nil')

    gm.group_id = 4
    assert(gm.valid?, 'membership has a user and a group')
  end

  test 'is_admin must not be empty' do
    gm = GroupMembership.new(:user_id => 1, :group_id => 1)
    assert(gm.invalid?, 'is_admin is nil')

    gm.is_admin = true
    assert(gm.valid?, 'is_admin is present')
  end
end
