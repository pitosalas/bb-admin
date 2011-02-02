require File.dirname(__FILE__) + '/../test_helper'

class ClientErrorTest < Test::Unit::TestCase
  set_fixture_class :clienterrors => ClientError
  fixtures :clienterrors

  # Tests making summaries
  def test_summary
    s = ClientError.summary
    assert_equal 2, s.length
    
    v = s[0]
    assert_equal '2.0', v[:version]
    assert_equal 2, v[:cnt]
    
    v = s[1]
    assert_equal '1.0', v[:version]
    assert_equal 3, v[:cnt]
  end
  
  # Tests grouping of errors
  def test_groups
    # Beginning, no conditions
    gs = ClientError.groups(0, 10, '')
    answers = [
      [201, '2.0', 2, 'Error type 2'],
      [101, '1.0', 1, 'Error type 1'],
      [102, '1.0', 1, 'Error type 2'],
      [103, '1.0', 1, 'Error type 2']]
    assert_groups answers, gs
    
    # Let's two in the middle
    gs = ClientError.groups(1, 2, '')
    answers = [
      [101, '1.0', 1, 'Error type 1'],
      [102, '1.0', 1, 'Error type 2']]
    assert_groups answers, gs
    
    # Let's filter version 2.0
    # Beginning, no conditions
    gs = ClientError.groups(0, 10, 'version = "1.0"')
    answers = [
      [101, '1.0', 1, 'Error type 1'],
      [102, '1.0', 1, 'Error type 2'],
      [103, '1.0', 1, 'Error type 2']]
    assert_groups answers, gs
  end
  
  # Tests how errors with similar versions, details and messages are deleted
  def test_delete_similar
    cnt = ClientError.count
    
    # Delete unique error just for test
    ClientError.delete_similar(@v1_1.id)
    assert_equal cnt - 1, ClientError.count

    # Delete the group of errors    
    ClientError.delete_similar(@v2_1.id)
    assert_equal cnt - 3, ClientError.count
  end
  
  # Tests how the hole group of errors for the given version is deleted
  def test_delete_version
    total = ClientError.count
    
    # Deleting non-existing version
    ClientError.delete_version('crap')
    assert_equal total, ClientError.count, "Nothing should be deleted"
    
    # Get the summar of errors per version and remove all one by one
    summary = ClientError.summary
    summary.each do |s|
      version = s[:version]
      cnt = s[:cnt]
      
      ClientError.delete_version(version)
      total -= cnt
      assert_equal total, ClientError.count, "Totals don't match"
    end
  end
  
  # Checks if answers and groups are equal
  def assert_groups answers, groups
    assert_equal answers.length, groups.length
    
    # Convert answers into the list of strings
    answers_s = answers.map { |a| a.join('_') }
    
    # Check each group
    groups.each do |g|
      v = "#{g[:id]}_#{g[:version]}_#{g[:cnt]}_#{g[:message]}"
      fail "Missing result: #{v}" if !answers_s.include?(v)
      
      answers_s.delete(v)
    end
    
    assert_equal 0, answers_s.length, "#{answers_s.length} answers left"
  end
end
