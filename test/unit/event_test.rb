require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :plans, :users
  
  # Test CRUD
  def test_crud
    # Create event and save
    e = Event.new(
      :user_id => @free_user.id,
      :created_at => Time.now,
      :event_type => 1,
      :description => "test")
    assert e.save
    assert e, Event.find(e.id)
    
    # Update event -- we don't do this
    
    # Delete event
    e.destroy
    begin
      Event.find(e.id)
      fail "Exception is expected"
    rescue
      # Expected
    end
  end  
end
