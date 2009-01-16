require File.dirname(__FILE__) + '/../test_helper'
require 'back_controller'

# Re-raise errors caught by the controller.
class BackController; def rescue_action(e) raise e end; end

class BackControllerTest < Test::Unit::TestCase
  def setup
    @controller = BackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Checks the trials
  def test_check_trials
    assert true
  end
  
  def test_report_expired
  end
  
end
