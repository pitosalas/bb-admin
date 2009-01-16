require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < Test::Unit::TestCase
  # Cleanup
  def teardown
    Message.delete_all
  end
  
  # Tests CRUD
  def test_crud
    # Create
    m = Message.new(
      :title => 'm1',
      :text => 't1',
      :version => '0.0',
      :priority => 2,
      :mtype => 2)
    assert m.save
    assert m, Message.find(m.id)
    
    # Update - we don't do this
    
    # Delete
    m.destroy
    assert !Message.exists?(m.id)
  end
end
