require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'event must have a name' do
    e = Event.new
    assert(e.invalid?, 'name is nil')

    e.name = 'Christmas party'
    assert(e.valid?, 'event has a name')
  end
end
