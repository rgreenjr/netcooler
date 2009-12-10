require File.dirname(__FILE__) + '/../test_helper'

class OfficeTest < Test::Unit::TestCase
  
  def setup
    @acme = Company.create!(:name => 'Acme, Inc', :url => 'http://www.acme.com/', :industry => Industry.find_by_name('Technology'))
  end
  
  def test_associations
    assert_working_associations
  end

  def test_invalid_with_empty_attributes
    office = Office.new
    assert !office.valid?
    assert office.errors.invalid?(:city)
    assert office.errors.invalid?(:country)
  end
  
  def test_valid_with_required_attributes
    office = Office.new(:city => 'Springfield', :state => State.find_by_abbreviation('IL'), :country => Country.find_by_name('United States'))
    assert @acme.offices << office, office.errors.full_messages
    assert office.valid?
  end
  
  def test_valid_with_all_attributes
    office = Office.new(:street1 => '123 Main Street', :street2 => 'Suite 200', :city => 'Springfield', 
      :country => Country.find_by_name('United States'), :state => State.find_by_abbreviation('IL'), :zip => '27894')
    assert office.valid?, office.errors.full_messages
    assert @acme.offices << office
  end
  
  def test_state_must_be_associated_with_country
    office = Office.new(:street1 => '123 Main Street', :street2 => 'Suite 200', :city => 'Springfield', 
      :country => Country.find_by_code('GB'), :state => State.find_by_abbreviation('IL'), :zip => '27894')
    assert !office.valid?
    assert_equal(["State or Province does not belong to specified country"], office.errors.full_messages)
    assert office.errors.invalid?(:state)
  end
  
end
