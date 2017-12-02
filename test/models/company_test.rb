require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'must have a name' do
    c = Company.new
    assert(c.invalid?, 'name is nil')

    c.name = "SFU"
    assert(c.valid?, 'company has a name')
  end

  test "descriptions can't be longer than a tweet" do
    c = Company.new(:name => 'UBC')
    assert(c.valid?, 'description is nil, which is fine')

    c.description = 'a' * 141
    assert(c.invalid?, 'description is > 140 characters')

    c.description = "don't come to this university"
    assert(c.valid?, 'description has acceptable length')
  end
end
