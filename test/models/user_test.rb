require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users	 # temporarily includes users in test/fixtures/users.yml for testing

  test 'names have realistic length' do
    u = User.new('email' => 'banana@hotmail.com')
    assert(u.invalid?, 'name is nil')

    u.name = 'x' * 51
    assert(u.invalid?, 'name is too long')

    u.name = 'Steve'
    assert(u.valid?, 'name is < 50 characters')
  end

  test 'emails have correct format' do
    u = User.new('name' => 'Steve')
    assert(u.invalid?, 'email is nil')

    u.email = 'this_is@notright'
    assert(u.invalid?, 'email has incorrect format')

    u.email = 'this_works@gmail.com'
    assert(u.valid?, 'email has correct format')
  end

  test 'no duplicate emails' do
    u = User.new
    u.email = 'hello@hotmail.com'
    # puts users(:one).email
    assert u.invalid?
  end
end
