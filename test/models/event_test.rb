require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'must have a name' do
    e = Event.new(:date => Date.today, :location_city => 'Burnaby', :location_address => '1234 Blueberry Road')
    assert(e.invalid?, 'name is nil')

    e.name = 'Christmas party'
    assert(e.valid?, 'event has a name')
  end

  test 'must have a date' do
    e = Event.new(:name => 'something', :location_city => 'Burnaby', :location_address => '1234 Blueberry Road')
    assert(e.invalid?, 'date is nil')

    e.date = Date.today
    assert(e.valid?, 'event has a date')
  end

  test 'must have an address' do
    e = Event.new(:name => 'something', :date => Date.today, :location_city => 'Burnaby')
    assert(e.invalid?, 'address is nil')

    e.location_address = '1234 Huckleberry Lane'
    assert(e.valid?, 'event has an address')
  end

  test 'must have a city' do
    e = Event.new(:name => 'something', :date => Date.today, :location_address => '1234 Blueberry Road')
    assert(e.invalid?, 'city is nil')

    e.location_city = 'New York'
    assert(e.valid?, 'event has a city')
  end
end
