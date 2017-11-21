require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  fixtures :groups	 # temporarily includes users in test/fixtures/groups.yml for testing

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

    # note: when testing methods that use db calls, must save new objects to the db
    # (eg. by using 'create' rather than just 'new')

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

  test 'typeOfAccess returns correct type' do
    # note: have to pass in emails and names when creating users because their presence
    # is validated (otherwise, they won't save). Didn't have to in test above bc that
    # method didn't call db to look for any User objects, whereas this one does

    # create new group
    g = Group.create(:id => 1)

    # create new admin user
    u1 = User.create(:id => 1, :is_admin => true, :name => 'Harry', :email => 'harry@hogwarts.com')
    assert_equal('view', g.typeOfAccess(g, u1), 'user is an admin; they have access to all groups')


    # create new non-admin user
    u2 = User.create(:id => 2, :is_admin => false, :name => 'Ron', :email => 'ron@hogwarts.com')
    assert_equal('join', g.typeOfAccess(g, u2), 'user has not sent a group request')

    gr = GroupRequest.create(:user_id => u2.id, :group_id => g.id, :status => 'pending')
    assert_equal('pending', g.typeOfAccess(g, u2), 'user has sent a request')

    gr.update_attribute('status', 'denied')
    # note: this is the same as gr.status = 'denied', followed by gr.save
    assert_equal('denied', g.typeOfAccess(g, u2), "user's request was denied")

    gr.update_attribute('status', 'accepted')
    gm = GroupMembership.create(:user_id => u2.id, :group_id => g.id)
    assert_equal('view', g.typeOfAccess(g, u2), 'user is already a member of group')
  end

  test 'get_admin returns correct admin id' do
    # add a group admin to a group
    u1 = User.create(:id => 1, :name => 'Snape', :email => 'sever@us.ca')
    g = Group.create(:id => 1)
    gm1 = GroupMembership.create(:group_id => g.id, :user_id => u1.id, :is_admin => true)
    assert_equal(1, g.get_admin(g), 'admin only member; their id is returned')

    # add a non-admin to the same group
    u2 = User.create(:id => 2, :name => 'Dumbledore', :email => 'wizardz_rule@gmail.com')
    gm2 = GroupMembership.create(:group_id => g.id, :user_id => u2.id, :is_admin => false)
    assert_equal(1, g.get_admin(g), "> 1 member in group; admin's id is returned")
  end
end
