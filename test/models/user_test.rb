require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users	 # temporarily includes users in test/fixtures/users.yml for testing

  test 'names have realistic length' do
    u = User.new('email' => 'banana@hotmail.com', :is_admin => false)
    assert(u.invalid?, 'name is nil')

    u.name = 'x' * 51
    assert(u.invalid?, 'name is too long')

    u.name = 'Steve'
    assert(u.valid?, 'name is < 50 characters')
  end

  test 'emails have correct format' do
    u = User.new('name' => 'Steve', :is_admin => false)
    assert(u.invalid?, 'email is nil')

    u.email = 'this_is@notright'
    assert(u.invalid?, 'email has incorrect format')

    u.email = 'this_works@gmail.com'
    assert(u.valid?, 'email has correct format')
  end

  test 'no duplicate emails' do
    u = User.new(:name => 'George', :is_admin => false)
    u.email = 'hello@hotmail.com'
    puts users(:one).email
    assert(u.invalid?, 'a user with this email already exists')

    u.email = "byee@gmail.com"
    assert(u.valid?, 'has a unique email')
  end

  test 'is_admin must not be empty' do
    u = User.new(:name => 'Sam', :email => 'raiya@hi.com')
    assert(u.invalid?, 'is_admin is nil')

    u.is_admin = true
    assert(u.valid?, 'is_admin is present')
  end
end
