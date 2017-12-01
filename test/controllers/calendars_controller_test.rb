require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  test "should get redirect" do
    get :redirect
    assert_response :success
  end

  test "should get callback" do
    get :callback
    assert_response :success
  end

  test "should get calendars" do
    get :calendars
    assert_response :success
  end

  test "should get events" do
    get :events
    assert_response :success
  end

  test "should get new_event" do
    get :new_event
    assert_response :success
  end

end
