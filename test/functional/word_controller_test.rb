require File.dirname(__FILE__) + '/../test_helper'
require 'word_controller'

# Re-raise errors caught by the controller.
class WordController; def rescue_action(e) raise e end; end

class WordControllerTest < Test::Unit::TestCase
  fixtures :words
  def setup
    @controller = WordController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @failed_word_no_name = { :name => "", :lang => "en" }
    @failed_word_no_lang = { :name => "decline", :lang => "" }
  end

  def test_get_new_page
    get :new
    assert_response :success
    assert_template 'new'
  end

  def XXXtest_failed_create_should_render_new
    #FIXME: how can a controller method with no
    # view with the same name be tested?
    post :create, :word => @failed_word_no_name
    assert_template 'new'
  end

  def test_should_show_pair
    get :pair
    assert_response :success
    assert_template 'pair'
    assert_not_nil assigns(:word1)
    assert_not_nil assigns(:word2)
    assert_select 'form li', :at_least => 2
  end

end
