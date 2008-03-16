require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_should_require_login
    u = User.create(:login => nil)
    assert u.errors.on(:login)
  end
end
