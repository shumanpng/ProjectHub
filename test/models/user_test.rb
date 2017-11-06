require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users	 # temporarily includes users in test/fixtures/users.yml for testing

  test "email can't have incorrect format" do
    u = User.new
    assert(u.invalid?, "email is nil")
    u.email = "this email's not right"
    assert(u.invalid?, "email has incorrect format")
  end

  test "no duplicate emails" do
    u = User.new
    u.email = "hello@hotmail.com"
    # puts users(:one).email
    assert u.invalid?
  end
end
