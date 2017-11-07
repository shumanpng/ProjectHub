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
  end

  test "created by cannot be empty" do
    task = Task.new('title' => 'write tests', 'state' => 'in progress')
    assert(task.invalid?, 'task creator field cannot be nil')
  end

  test "state field cannot be empty" do
    task = Task.new('title' => 'write tests', 'created_by' => 'Smith')
    assert(task.invalid?, 'state field cannot be nil')
  end

end
