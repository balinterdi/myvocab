require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @user = User.create(:email => 'john@company.com', :login => 'john', :password => 'passtoguess')
  end

  def test_should_require_login
    u = User.create(:login => nil)
    assert u.errors.on(:login)
  end

  def test_login_length_short
    u = User.create(:login => 'go')
    assert u.errors.on(:login)
  end

  def test_login_length_good
    u = User.create(:login => 'bryan')
    assert_equal(nil, u.errors.on(:login))
  end

  def test_should_require_password
    u = User.create(:password => nil)
    assert u.errors.on(:password)
  end

  def test_password_length_short
    u = User.create(:password => 'pass')
    assert u.errors.on(:password)
  end

  def test_password_length_good
    u = User.create(:password => 'passtoguess')
    assert_equal(nil, u.errors.on(:password))
  end

  def test_should_require_email
    u = User.create(:email => nil)
    assert u.errors.on(:email)
  end

  def test_email_length
    u = User.create(:email => 'x@x.x')
    assert u.errors.on(:email)
  end

  def test_email_format
    u = User.create(:email => 'halleluja')
    assert u.errors.on(:email)
  end

  def test_email_format_correct
    u = User.create(:email => 'bryan@company.com')
    assert_equal(nil, u.errors.on(:email))
  end

  def test_authenticate_no_such_login
    assert_equal(nil, User.authenticate('sebastien', 'passtoguess'), 'no such login')
  end

  def test_authenticate_bad_password
    assert_equal(nil, User.authenticate('john', 'qwerty'), 'bad password')
  end

  def test_authenticate_success
    assert_equal(@user, User.authenticate('john', 'passtoguess'), 'successful user authentication')
  end

end
