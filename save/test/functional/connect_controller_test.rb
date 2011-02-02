require File.dirname(__FILE__) + '/../test_helper'
require 'connect_controller'

# Re-raise errors caught by the controller.
class ConnectController; def rescue_action(e) raise e end; end

class ConnectControllerTest < Test::Unit::TestCase
  def setup
    @controller = ConnectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
