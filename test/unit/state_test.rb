require File.dirname(__FILE__) + '/../test_helper'

class StateTest < Test::Unit::TestCase
      
  def test_associations
    assert_working_associations
  end

  def test_invalid_with_empty_attributes
    state = State.new
    assert !state.valid?
    assert state.errors.invalid?(:name)
    assert_equal "can't be blank", state.errors[:name]
    assert state.errors.invalid?(:abbreviation)
    assert_equal "can't be blank", state.errors[:abbreviation]
  end
  
  def test_invlaid_unless_unique
    state = State.new(:name => 'Texas', :abbreviation => 'TX')
    assert !state.valid?
    assert state.errors.invalid?(:name)
    assert_equal "has already been taken", state.errors[:name]
    assert state.errors.invalid?(:abbreviation)
    assert_equal "has already been taken", state.errors[:abbreviation]
    assert !state.save
  end
  
  def test_valid_with_attributes
    state = State.new(:name => 'New Texas', :abbreviation => 'NT', :country => Country.find_by_name('United States'))
    assert state.valid?
    assert state.save
  end

  def test_all_by_name
    all = State.all_by_name
    assert_equal('Alabama', all.first.name)
    assert_equal('Wyoming', all.last.name)
  end
  
end
