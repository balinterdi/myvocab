require File.dirname(__FILE__) + '/../test_helper'
require 'words_controller'

# Re-raise errors caught by the controller.
class WordsController; def rescue_action(e) raise e end; end

class WordsControllerTest < Test::Unit::TestCase
  def setup
    @controller = WordsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
