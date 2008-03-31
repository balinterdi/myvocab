require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'
require 'application'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @successful_register_opts = { :login => 'bryan', :email => 'bryan@bryan.com', :password => 'bryanpass', :password_confirmation => 'bryanpass' }
    @failing_register_opts_no_password = { :login => 'bryan', :email => 'bryan@bryan.com' }
    @failing_register_opts_badly_repeated_password = { :login => 'bryan', :email => 'bryan@bryan.com', :password_confirmation => 'xxxbryanpass' }

    @successful_login_opts = { :login => 'bryan', :password => 'bryanpass' }
    @failing_login_opts_nonexistent_user = { :login => 'bryan_the_rabbit', :password => 'bryanpass' }
    @failing_login_opts_bad_password = { :login => 'bryan', :password => 'xxxbryanpass' }
  end

  # see http://manuals.rubyonrails.com/read/chapter/28
  def test_get_register_page
    get :register
    assert_response :success
    assert flash.blank?
    # tests if @user is set in the controller
    assert_not_nil assigns['user'], "User is not created"
    assert_template 'register'
    #FIXME: maybe remove duplication of :tag => 'form' with
    # something like:
    # with_assert_tag :tag => 'form' do
    # ...
    # end
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'text', :name => 'user[name]' } }
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'text', :name => 'user[login]' } }
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'text', :name => 'user[email]' } }
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'password', :name => 'user[password]' } }
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'password', :name => 'user[password_confirmation]' } }
    assert_tag :tag => 'form', :descendant => { :tag => 'input', :attributes => { :type => 'submit' } }
  end

  def test_failed_register
    post :register, :user => @failing_register_opts_no_password
    assert_not_nil flash[:error]
    post :register, :user => @failing_register_opts_badly_repeated_password
    assert_not_nil flash[:error]
    assert_response :success
    assert_template 'register'
  end

  def test_failed_register_does_not_set_session
    post :register, :user => @failing_register_opts_no_password
    assert @controller.current_user_id.blank?
  end

  def test_successful_register
    post :register, :user => { :login => 'bryan', :email => 'bryan@bryan.com', :password => 'bryanpass', :password_confirmation => 'bryanpass' }
    #FIXME: test if successful registration message is displayed,
    # but without duplicating it (once defining it in the test and once in the view, e.g)
    assert_nil flash[:error]
  end

  def test_successful_register_redirects_to_home
    post :register, :user => @successful_register_opts
    assert_redirected_to home_url
  end

  def test_successful_register_sets_session
    post :register, :user => @successful_register_opts
    assert !@controller.current_user_id.blank?
    assert_equal User.find_by_login(@successful_register_opts[:login]).id, @controller.current_user_id
  end

  def test_login_should_fail_if_nonexistent_user
    post :login, :user => @failing_login_opts_nonexistent_user
    assert @controller.current_user_id.blank?
  end

  def test_login_should_fail_if_bad_password
    post :login, :user => @failing_login_opts_bad_password
    assert @controller.current_user_id.blank?
  end

  def test_login_fails_renders_login
    post :login, :user => @failing_login_opts_bad_password
    assert_response :success
    assert_template 'login'
  end

  def test_login_fails_renders_flash_error
    post :login, :user => @failing_login_opts_bad_password
    assert !flash[:error].blank?
  end

  def stub_successful_login
    user = User.create(@successful_register_opts)
    User.stubs(:authenticate).returns(user)
    return user
  end

  def test_successful_login_sets_session
    #FIXME: this stubbing should be refactored
    user = stub_successful_login
    post :login, :user => @successful_login_opts
    assert_equal user.id, @controller.current_user_id
  end

  def test_successful_login_redirects_to_home_page
    user = stub_successful_login
    post :login, :user => @successful_login_opts
    assert_redirected_to home_url
  end

  def test_successful_login_no_error_message
    user = stub_successful_login
    post :login, :user => @successful_login_opts
    assert flash[:error].blank?
  end

  def test_logout_deletes_user_session
    user = stub_successful_login
    post :login, :user => @successful_login_opts
    get :logout
    assert_nil @controller.current_user_id
  end

  def test_logout_redirects_to_home_page
    user = stub_successful_login
    post :login, :user => @successful_login_opts
    get :logout
    assert_redirected_to home_url
  end

end
