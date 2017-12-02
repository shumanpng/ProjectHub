require 'test_helper'

class GroupRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'request must be associated with a group and a user' do
    gr = GroupRequest.new(:status => 'denied')
    assert(gr.invalid?, 'user_id & group_id are both nil')

    gr.user_id = 2
    assert(gr.invalid?, 'group_id is still nil')

    gr.group_id = 4
    assert(gr.valid?, 'request has a user and a group')
  end

  test "status is one of 'pending', 'denied', or 'accepted'" do
    gr = GroupRequest.new(:user_id => 1, :group_id => 1)
    assert(gr.invalid?, 'status is nil')

    gr.status = 'not right!'
    assert(gr.invalid?, 'status not one of the acceptable values')

    gr.status = 'pending'
    assert(gr.valid?, 'status is acceptable')
  end
end
