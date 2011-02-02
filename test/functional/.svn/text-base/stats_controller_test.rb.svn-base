require File.dirname(__FILE__) + '/../test_helper'
require 'stats_controller'

# Re-raise errors caught by the controller.
class StatsController; def rescue_action(e) raise e end; end

class StatsControllerTest < Test::Unit::TestCase
  fixtures :plans, :users

  def setup
    @controller = StatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    get :index
    
    assert_response :success
    assert_template 'index'
    
    assert_not_nil assigns(:plans)
    assert_not_nil assigns(:monthly_income)
    
    assert_equal 11, assigns(:monthly_income)
    assert_equal 1, assigns(:paying_users)
  end
end
