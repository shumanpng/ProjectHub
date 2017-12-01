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
end
