require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  fixtures :groups	 # temporarily includes users in test/fixtures/users.yml for testing

  # This test is needed because a lot of the implementation of Tasks relies on having
  # unique group names
  test 'no duplicate names' do
    g = Group.new
    assert(g.invalid?, 'name is nil')

    g.name = 'Gryffindor'
    puts groups(:one).name
    assert(g.invalid?, 'a group with this name already exists')

    g.name = 'Hufflepuff'
    assert(g.valid?, 'group has a unique name')
  end

  test 'get_user_status returns correct case' do
    # note: need to explicitly pass in unique id's when creating user objects below because
    # the method compares id's of different users, but calling create in test environment
    # for some reason only generates 'nil' id's.

    # set up situation for case d.
    u1 = User.create(:id => 1)
    g = Group.create(:id => 1)
    gm1 = GroupMembership.create(:user_id => u1.id, :group_id => g.id, :is_admin => true)
    assert_equal('none left', g.get_user_status(g, u1), 'case d.: user is the group
    admin but there are no other members')

    # set up situation for cases b. and a.
    u2 = User.create(:id => 2)
    gm2 = GroupMembership.create(:user_id => u2.id, :group_id => g.id, :is_admin => false)
    assert_equal('one left', g.get_user_status(g, u1), 'case b.: user is the group admin
    and there is one other member')
    assert_equal('not admin', g.get_user_status(g, u2), 'case a.: user is not the group admin')

    # set up situation for case c.
    u3 = User.create(:id => 3)
    gm3 = GroupMembership.create(:user_id => u3.id, :group_id => g.id, :is_admin => false)
    assert_equal('not admin', g.get_user_status(g, u3), 'case a.: user is not the group admin')
    assert_equal('many left', g.get_user_status(g, u1), 'case c.: user is the group
    admin and there are multiple other members')
  end
end
