require File.dirname(__FILE__) + '/../test_helper'

class CompanyTest < Test::Unit::TestCase
  
  fixtures  :companies, :offices, :states, :industries, :posts, :countries
    
  def setup
    @apple = companies(:apple)
    @google = companies(:google)
    @texas = states(:texas)
    @usa = countries(:usa)
    @apple_office = offices(:apple_office)
    @apple_news = posts(:apple_iphone_news)
    @google_news = posts(:google_ipo_news)
  end
  
  def test_associations
    assert_working_associations
  end

  def test_invalid_without_attributes
    company = Company.new
    assert !company.valid?
    assert company.errors.invalid?(:name)
    assert company.errors.invalid?(:url)
    assert company.errors.invalid?(:industry)
  end
  
  def test_adding_office
    assert @apple.offices << Office.new(:city => 'Austin', :state => @texas, :country => @usa)
    assert @apple.save, @apple.errors.full_messages
    assert_equal 'Austin', @apple.offices.last.city
    assert_equal @texas, @apple.offices.last.state
  end
  
  def test_adding_invalid_office
    @apple.offices << Office.new(:state => @texas)
    assert !@apple.save
  end
  
  def test_atom_id
    assert_equal("tag:netcooler.com,#{@apple.created_at.strftime("%Y-%m-%d")}:/companies/#{@apple.id}", @apple.atom_id)
  end
  
  def test_find_by_company
    @apple_news.tag_string = 'innovative'
    @apple_news.save
    @apple_news.reload
    assert_equal(1, @apple_news.tags.size)
        
    @google_news.tag_string = 'aa bb cc dd innovative'
    assert @google_news.save
    @google_news.reload
    assert_equal(5, @google_news.tags.size)
    
    all_tags = Tag.all_with_count
    apple_tags = @apple.tags
    google_tags = @google.tags
    not_google_tags = all_tags - google_tags
    not_apple_tags = all_tags - apple_tags

    assert apple_tags.collect {|t| t.name}.join(' ') == 'innovative'
    assert google_tags.collect {|t| t.name}.join(' ') == 'aa bb cc dd innovative'
    assert_equal(not_google_tags + google_tags, all_tags)
    assert_equal(not_apple_tags + apple_tags, all_tags)
  end
  
  def test_find_by_city
    company = Company.new(:name => "Acme, Inc.", :url => "http://www.acme.com/", :industry => Industry.find(:first))
    assert company.offices << Office.new(:city => 'Flagstaff', :state => State.find_by_name('Arizona'), :country => @usa)
    assert company.save
    matches = Company.find_by_city('Flagstaff')
    assert_equal(1, matches.size)
    assert_equal('Flagstaff', matches.first.city)
  end
  
  def test_find_by_state
    company = Company.new(:name => "Acme, Inc.", :url => "http://www.acme.com/", :industry => Industry.find(:first))
    assert company.offices << Office.new(:city => 'Flagstaff', :state => State.find_by_name('Arizona'), :country => @usa)
    assert company.save
    matches = Company.find_by_state('Arizona')
    assert_equal(1, matches.size)
    assert_equal('Arizona', matches.first.state_name)
  end
  
  def test_find_by_city_and_state
    company = Company.new(:name => "Acme, Inc.", :url => "http://www.acme.com/", :industry => Industry.find(:first))
    assert company.offices << Office.new(:city => 'Flagstaff', :state => State.find_by_name('Arizona'), :country => @usa)
    assert company.save
    matches = Company.find_by_city_and_state('Flagstaff', 'Arizona')
    assert_equal(1, matches.size)
    assert_equal('Flagstaff', matches.first.city)
    assert_equal('Arizona', matches.first.state_name)
  end
  
  def test_find_by_country
    assert true
  end
  
  def test_main_address
    company = Company.new(:name => "Acme, Inc.", :url => "http://www.acme.com/", :industry => Industry.find(:first))
    assert company.offices << Office.new(:city => 'Flagstaff', :state => State.find_by_name('Arizona'))
    assert_equal('Flagstaff, Arizona', company.main_address)
  end
  
end
