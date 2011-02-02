require File.dirname(__FILE__) + '/../test_helper'
require 'features_controller'

# Re-raise errors caught by the controller.
class FeaturesController; def rescue_action(e) raise e end; end

class FeaturesControllerTest < Test::Unit::TestCase
  fixtures :features

  def setup
    @controller = FeaturesController.new
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

    assert_not_nil assigns(:features)
    assert_not_nil assigns(:feature_pages)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:feature)
    assert assigns(:feature).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:feature)
  end

  def test_create
    num_features = Feature.count

    post :create, :feature => { :name => 'f', :title => 'F', :description => 'Fd', :format_description => 'Ffd', :default_value => 'Fdv' }

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_features + 1, Feature.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:feature)
    assert assigns(:feature).valid?
  end

  def test_update
    post :update, :id => 1, :feature => { :name => 's', :title => 'S', :description => 'Sd', :format_description => 'Sfd', :default_value => 'Sdv' }
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
    
    # Test how serials are updated on feature update
    Plan.find_all.each { |p| assert_equal 1, p.serial }
  end

  def test_destroy
    assert_not_nil Feature.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Feature.find(1)
    }
  end
end
