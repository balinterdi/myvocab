require File.dirname(__FILE__) + '/../test_helper'
require 'meaning_controller'

# Re-raise errors caught by the controller.
class MeaningController; def rescue_action(e) raise e end; end

class MeaningControllerTest < Test::Unit::TestCase
  def setup
    @controller = MeaningController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
