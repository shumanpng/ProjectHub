require 'test_helper'

class TaskCommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'comment must not be empty' do
    tc = TaskComment.new(:task_id => 1, :user_id => 1, :user_name => 'Raiya')
    assert(tc.invalid?, 'comment is nil')

    tc.task_comment = "i'm a comment!"
    assert(tc.valid?, 'comment actually has a comment!')
  end

  test 'comment must be associated w/ a task and a user' do
    tc = TaskComment.new(task_comment: 'blah blah')
    assert(tc.invalid?, 'task_id, user_id and user_name are nil')

    tc.task_id = 1
    assert(tc.invalid?, 'comment still has no user')

    tc.user_id = 2
    assert(tc.invalid?, 'user_name is still nil')

    tc.user_name = 'Harry Potter'
    assert(tc.valid?, 'comment has a task and a user')
  end
end
