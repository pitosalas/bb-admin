require File.dirname(__FILE__) + '/../test_helper'

class PlanTest < Test::Unit::TestCase
  fixtures :plans, :features

  def setup
    # We remove all plans features before tests because
    # Rails never reloads the plans from the table if they
    # were not changed
    PlansFeature.delete_all
  end
  
  # Testing CRUD
  def test_plan_crud
    # Create
    p = Plan.new
    p.name = "name"
    p.description = "descr"
    p.price = 1
    p.period_months = 10
    p.save
    
    # Read back and test
    l = Plan.find(p.id)
    assert_equal l, p
    
    # Update
    p.name = "name2"
    p.description = "descr2"
    p.price = 2
    p.period_months = 20
    p.save
    
    # Check the updates
    l = Plan.find(p.id)
    assert_equal l, p
    
    # Remove
    assert p.destroy
    
    # Check if removed
    begin
      Plan.find(p.id)
      fail "Exception was expected"
    rescue
      # Expected
    end
  end
  
  # Tests adding a feature to the plan
  def test_add_feature
    # Add plan feature
    @free_plan.add_feature(@first_feature.id, 'af1')
    
    # Check
    lpf = PlansFeature.find(:first)
    assert_equal @free_plan.id, lpf.plan_id
    assert_equal @first_feature.id, lpf.feature_id
    assert_equal 'af1', lpf.value
  end
  
  # Tests removing all features assigned to the plan
  def test_clear_features
    # Add a test feature both to free and basic plans
    @free_plan.add_feature(@first_feature.id, 'f1')
    @basic_plan.add_feature(@first_feature.id, 'f2')
    
    # Clear features of free plan
    @free_plan.clear_features
    
    begin
      PlansFeature.find(:first, :conditions => "plan_id = #{@free_plan.id}")
      fail "No records should be found"
    rescue
      # Expected
    end
    
    bpf = PlansFeature.find(:first, :conditions => "plan_id = #{@basic_plan.id}")
    assert_equal 'f2', bpf.value
  end
  
  # Tests the list of features with overriden values
  def test_all_features
    feature_values = {}
    @features.values.each do |v|
      feature_values[v['title']] = v['default_value'].to_s
    end
    
    # Get the list of features for a clean plan
    fs = @free_plan.all_features
    assert_equal @features.length, fs.length
    fs.each do |f|
      assert_equal feature_values[f['title']], f['value']
      assert_equal '0', f['overriden'], PlansFeature.find(:all).inspect
    end
    
    # Override the feature and test
    @free_plan.add_feature(@first_feature.id, 'override')
    fs = @free_plan.all_features
    assert_equal @features.length, fs.length
    fs.each do |f|
      if f['title'] == @first_feature.title
        assert_equal 'override', f['value']
        assert_equal '1', f['overriden']
      else
        assert_equal feature_values[f['title']], f['value']
        assert_equal '0', f['overriden'], f['title'] + ' can\'t have overriden value ' + f['value']
      end
    end
  end
  
  # Tests the list of features with overriden values only
  def test_overriden_features
    # Get the list of features for a clean plan
    fs = @free_plan.overriden_features
    assert_equal @features.length, fs.length
    fs.each { |f| assert_nil f['plan_value'] }
    
    # Override the feature and test
    @free_plan.add_feature(@first_feature.id, 'override')
    fs = @free_plan.overriden_features
    assert_equal @features.length, fs.length
    fs.each do |f|
      if f['title'] == @first_feature.title
        assert_equal 'override', f['plan_value']
      else
        assert_nil f['plan_value']
      end
    end
  end
end
