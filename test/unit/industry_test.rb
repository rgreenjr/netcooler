require File.dirname(__FILE__) + '/../test_helper'

class IndustryTest < Test::Unit::TestCase
      
  def test_associations
    assert_working_associations
  end

  def test_invalid_with_empty_attributes
    industry = Industry.new
    assert !industry.valid?
    assert industry.errors.invalid?(:name)
    assert_equal "can't be blank", industry.errors[:name]
  end
  
  def test_invlaid_unless_unique
    industry = Industry.new(:name => 'Technology')
    assert !industry.valid?
    assert industry.errors.invalid?(:name)
    assert_equal "has already been taken", industry.errors[:name]
    assert !industry.save
  end
  
  def test_valid_with_attributes
    industry = Industry.new(:name => 'X-Technology')
    assert industry.valid?
    assert industry.save
  end
  
end
