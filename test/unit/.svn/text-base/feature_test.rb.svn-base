require File.dirname(__FILE__) + '/../test_helper'

class FeatureTest < Test::Unit::TestCase

  # Tests creation, updates and removal
  def test_crud
    # Create
    f = Feature.new(
      :name => '1',
      :title => 't1',
      :description => 'd1',
      :format_description => 'fd1',
      :default_value => 'dv1',
      :hidden => false)
    assert f.save
    assert f, Feature.find(f.id)
    
    # Update
    f.name = '2'
    f.title = 't2'
    f.description = 'd2'
    f.format_description = 'fd2'
    f.default_value = 'dv2'
    f.hidden = true
    assert f.save
    assert f, Feature.find(f.id)
    
    # Destroy
    f.destroy
    begin
      Feature.find(f.id)
      fail "Exception is expected"
    rescue
      # Expected
    end
  end
  
end
