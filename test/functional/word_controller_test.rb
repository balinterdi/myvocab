require File.dirname(__FILE__) + '/../test_helper'
require 'word_controller'

# Re-raise errors caught by the controller.
class WordController; def rescue_action(e) raise e end; end

class WordControllerTest < Test::Unit::TestCase
  # fixtures :words

  def setup
    @controller = WordController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @failed_word_no_name = { :name => "", :lang => "en" }
    @failed_word_no_lang = { :name => "decline", :lang => "" }

		# FIXME: this redefinition of model instance stubs is a violation of DRY since they are already 
		# defined in user_controller_test.rb,
		# but where should I define them to be DRY then?
    @english = Language.create(:name => "english", :code => "en")
		@successful_register_opts = { :login => 'bryan', :email => 'bryan@bryan.com', :first_language => @english.id,
			:password => 'bryanpass', :password_confirmation => 'bryanpass' }
		@successful_login_opts = { :login => 'bryan', :password => 'bryanpass' }

    @logged_user = stub_successful_login(@successful_register_opts)

    post :login, :user => @successful_login_opts
  end

  def test_get_new_page_no_login_redirects_to_login
    get :new
    assert_redirected_to login_url
  end

  def test_get_new_page
    # user = stub_successful_login(@successful_register_opts)
    @controller.stubs(:check_authentication).returns(true)
		@controller.stubs(:current_user_id).returns(@logged_user.id)

    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_get_pair_page_no_login_redirects_to_login
    get :pair
    assert_redirected_to login_url
  end

  def XXXtest_failed_create_should_render_new
    #FIXME: how can a controller method with no
    # view with the same name be tested?
    post :create, :word => @failed_word_no_name
    assert_template 'new'
  end

  def XXXtest_should_show_pair
    #TODO: finish this
    @controller.stubs(:check_authentication).returns(true)
    get :pair
    assert_response :success
    assert_template 'pair'
    assert_not_nil assigns(:word1)
    assert_not_nil assigns(:word2)
    assert_select 'form li', :at_least => 2
  end

end
