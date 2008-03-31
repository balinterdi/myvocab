require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # see http://manuals.rubyonrails.com/read/chapter/28
  def test_get_register_page
    get :register
    assert_response :success
    assert flash.blank?
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
    post :register, :user => { :login => 'bryan', :email => 'bryan@bryan.com' }
    assert_not_nil flash[:notice]
    post :register, :user => { :login => 'bryan', :email => 'bryan@bryan.com', :password => 'bryanpass', :password_confirmation => 'xxxbryanpass' }
    assert_not_nil flash[:notice]
    post :register, :user => { :login => 'bryan', :email => 'bryan@bryan.com', :password => 'bryanpass', :password_confirmation => 'bryanpass' }
    assert_nil flash[:notice]
    # assert_redirected_to :controller => :user, :action => 'register'
  end

  def test_successful_register_redirects_to_home_page
  end



end
