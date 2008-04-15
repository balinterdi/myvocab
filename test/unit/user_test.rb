require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  def setup
    user_attributes = {
      :email => 'john@company.com',
      :login => 'john',
      :password => 'passtoguess',
      :password_confirmation => 'passtoguess' }
    user_with_first_language_attributes = user_attributes.merge({:first_language_id => 1})
    @user = User.create(user_attributes)
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
    assert_nil u.errors.on(:login)
  end

  def test_should_require_password
    u = User.create(:password => '')
    assert u.errors.on(:password)
  end

  def test_password_length_short
    u = User.create(:password => 'pass')
    assert u.errors.on(:password)
  end

  def test_password_length_good
    u = User.create(:password => 'passtoguess')
    assert_nil u.errors.on(:password)
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
    assert_nil u.errors.on(:email)
  end

  def test_email_unicity
    u = User.create(:email => @user.email)
    assert u.errors.on(:email)
  end

  def test_random_string
    assert_match(/^\w{7}$/, User.random_string(7))
    assert_match(/^\w{10}$/, User.random_string(10))
  end

  def test_set_password
    @user.update_attribute(:password, "new_password")
    assert_equal @user, User.authenticate(@user.login, "new_password")
  end

  def test_login_unicity
    u = User.create(:login => @user.login)
    assert u.errors.on(:login)
  end

  def test_authenticate_no_such_login
    assert_nil User.authenticate('sebastien', 'passtoguess'), 'no such login'
  end

  def test_authenticate_bad_password
    assert_nil User.authenticate('john', 'qwerty'), 'bad password'
  end

  def test_authenticate_success
    assert_equal @user, User.authenticate('john', 'passtoguess'), 'successful user authentication'
  end

  def test_save_first_language
    english = Language.create(:name => "english", :code => "en")
    # Language.stubs(:find).returns(english)
    @user.first_language_id = english.id
    assert_equal 1, @user.languages.size
    assert_equal english, @user.languages.first
    assert_equal 1, @user.learnings.size
    assert @user.learnings.first.is_first_language
    # assert_equal english, @user.learnings.first.language
  end

end
