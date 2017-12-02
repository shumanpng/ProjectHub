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
    task = Task.new('created_by' => 'Bob', 'state' => 'Open', :points => 1, :deadline => Date.current)
    assert(task.invalid?, 'task title cannot be nil')

    task.title = 'blah blah'
    assert(task.valid?, 'task has a title')
  end

  test "created by cannot be empty" do
    task = Task.new('title' => 'write tests', 'state' => 'In Progress', :points => 1, :deadline => Date.current)
    assert(task.invalid?, 'task creator field cannot be nil')

    task.created_by = 'Shuman'
    assert(task.valid?, 'task was created by someone')
  end

  test 'has a deadline' do
    t = Task.new(:title => 'laundry', :state => 'Open', :points => 2, :created_by => 'Bob')
    assert(t.invalid?, 'deadline is nil')

    t.deadline = Date.current
    assert(t.valid?, 'has a deadline')
  end

  test "state is one of 'Open', 'In Progress', or 'Completed'" do
    task = Task.new('title' => 'write tests', 'created_by' => 'Smith', :points => 1, :deadline => Date.current)
    assert(task.invalid?, 'state is nil')

    task.state = 'closed'
    assert(task.invalid?, 'state is invalid')

    task.state = 'in progress'
    assert(task.invalid?, 'state is not capitalized')

    task.state = 'Completed'
    assert(task.valid?, 'state is valid')
  end

  test 'comment count returns the right number' do
    # create a new task
    t = Task.create(title: 'cleaning', state: 'Open', created_by: 'Raiya', :points => 1, :deadline => Date.current)
    assert(t.valid?, 'task is valid')
    assert_equal(0, t.comment_count(t), 't has no comments yet')

    # create new comments, and associate them with the task
    tc1 = TaskComment.create(:task_comment => 'i hate cleaning', :task_id => t.id, :user_id => 1, :user_name => 'Bob')
    assert(tc1.valid?, 'comment is valid')
    assert_equal(1, t.comment_count(t), 'task has 1 comment')

    tc2 = TaskComment.create(:task_comment => "i'll mop the floors", :task_id => t.id, :user_id => 1, :user_name => 'Sam')
    assert(tc2.valid?, 'comment is valid')
    assert_equal(2, t.comment_count(t), 'task has 2 comments')
  end

  test '# of points between 1 and 5' do
    t = Task.new(:title => 'hullo', :state => 'Open', :created_by => 'Sam', :deadline => Date.current)
    assert(t.invalid?, 'points is nil')

    t.points = 'blah'
    assert(t.invalid?, 'points not a number')

    t.points = 14
    assert(t.invalid?, 'points out of range')

    t.points = 4
    assert(t.valid?, 'points within range')
  end

end
