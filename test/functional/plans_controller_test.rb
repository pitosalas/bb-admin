require File.dirname(__FILE__) + '/../test_helper'
require 'plans_controller'

# Re-raise errors caught by the controller.
class PlansController; def rescue_action(e) raise e end; end

class PlansControllerTest < Test::Unit::TestCase
  fixtures :plans

  def setup
    @controller = PlansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:plans)
    assert_not_nil assigns(:features)
    assert_not_nil assigns(:plan_features)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:plan)
    assert_not_nil assigns(:features)
    assert assigns(:plan).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:plan)
    assert_not_nil assigns(:features)
  end

  def test_create
    num_plans = Plan.count

    post :create, :plan => { :name => 'test', :description => 'test', :price => 1, :period_months => 3 },
      :features => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_plans + 1, Plan.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:plan)
    assert_not_nil assigns(:features)
    assert assigns(:plan).valid?
  end

  def test_update
    old_serial = Plan.find(1).serial
    
    post :update, :id => 1, :plan => { :name => 'test', :description => 'test', :price => '2', :period_months => '4' }, :features => {}
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # Every time we update a plan, its serial number increases
    assert_equal old_serial + 1, Plan.find(1).serial
  end

  def test_destroy
    assert_not_nil Plan.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Plan.find(1)
    }
  end
end
