require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :plans, :users

  def setup
    @controller = UsersController.new
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

    assert_not_nil assigns(:users)
    assert_not_nil assigns(:user_pages)
  end

  def test_unactivated
    # Outdated
    u = users(:first)
    u.registrationDate = Date.today - 356
    u.activated = 0
    u.save
    
    # Not outdated
    u = users(:second)
    u.registrationDate = Date.today - 5
    u.activated = 0
    u.save

    # Activated
    u = users(:third)
    u.registrationDate = Date.today - 356
    u.activated = 1
    u.save

    get :unactivated

    assert_response :success
    assert_template 'unactivated'

    assert_not_nil assigns(:users)
    assert_not_nil assigns(:user_pages)
    
    us = assigns(:users)
    assert_equal 1, us.length
    assert us.include?(users(:first))
  end

  def test_change_plan
    get :change_plan, :id => 1

    assert_response :success
    assert_template 'change_plan'

    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
  end

  def test_grant_unlimited
    post :grant_unlimited, :id => 1, :plan => { :id => 3 }
    
    assert_not_nil assigns(:user)
    
    u = User.find(1)
    assert_equal 3, u.plan_id
    assert_nil u.plan_exp_date
    assert_nil u.plan_price
    assert_nil u.plan_period_months
    assert !u.plan_is_trial
  end

  def test_grant_trial
    post :grant_trial, :id => 1, :date => { :year => '2007', :month => '10', :day => '24' }
    
    assert_not_nil assigns(:user)
    
    u = User.find(1)
    assert_equal Date.new(2007, 10, 24), u.plan_exp_date.to_date
    assert_equal plans(:pub).id, u.plan_id
    assert_nil u.plan_price
    assert_nil u.plan_period_months
    assert u.plan_is_trial
  end
  
  def test_delete
    get :delete, :id => 1
    
    assert !User.exists?(1)
  end
end
