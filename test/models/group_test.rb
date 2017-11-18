require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test 'case d.: only group admin left' do
    u = User.new
    g = Group.new
    gm = GroupMembership.new(:user_id => u.id, :group_id => g.id, :is_admin => false)

    assert_equal('none left', g.get_user_status(g, u), 'case d.: user is the group admin
    but there are no other members')
  end
end
