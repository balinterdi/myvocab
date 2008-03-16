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
  end

  def test_should_show_pair
    get :pair
    assert_response :success
    assert_template 'pair'
    assert_not_nil assigns(:word1)
    assert_not_nil assigns(:word2)
    assert_select 'form li', :count => 2
  end

end
