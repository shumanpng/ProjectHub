require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # fixtures :tasks
  # test "the truth" do
  #   assert true
  # end
  # test "title cannot be empty" do
  #   # @tasks.each do |task|
  #
  #     # assert_not_nil(task, msg = "title cannot be empty")
  #     # assert true
  #   # end
  # end


  # def test_true
  #   assert true
  # end

  test "title must not be empty" do
    task = Task.new('created_by' => 'Bob', 'state' => 'open')
    assert(task.invalid?, 'task title cannot be nil')

    task.title = 'blah blah'
    assert(task.valid?, 'task has a title')
  end

  test "created by cannot be empty" do
    task = Task.new('title' => 'write tests', 'state' => 'in progress')
    assert(task.invalid?, 'task creator field cannot be nil')

    task.created_by = 'Shuman'
    assert(task.valid?, 'task was created by someone')
  end

  test "state field cannot be empty" do
    task = Task.new('title' => 'write tests', 'created_by' => 'Smith')
    assert(task.invalid?, 'state field cannot be nil')

    task.state = 'Open'
    assert(task.valid?, 'task has a state')
  end

  test 'comment count returns the right number' do
    # create a new task
    t = Task.new(title: 'cleaning', state: 'Open', created_by: 'Raiya')
    assert(t.valid?, 'task is valid')
    assert_equal(0, t.comment_count(t), 't has no comments yet')

    # create new comments, and associate them with the task
    tc1 = TaskComment.create(:task_comment => 'i hate cleaning', :task_id => t.id)
    assert(tc1.valid?, 'comment is valid')
    assert_equal(1, t.comment_count(t), 'task has 1 comment')

    tc2 = TaskComment.create(:task_comment => "i'll mop the floors", :task_id => t.id)
    assert(tc2.valid?, 'comment is valid')
    assert_equal(2, t.comment_count(t), 'task has 2 comments')
  end

end
