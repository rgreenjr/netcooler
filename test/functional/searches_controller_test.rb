require File.dirname(__FILE__) + '/../test_helper'
require 'searches_controller'

# Re-raise errors caught by the controller.
class SearchesController; def rescue_action(e) raise e end; end

class SearchesControllerTest < ActionController::TestCase
  
  fixtures :industries
  
  def setup
    super

    @acme = Company.new(:name => "Acme, Inc.", :url => "http://www.acme.com/", :industry => Industry.find_by_name('Other'))
    @acme.offices << Office.new(:city => 'Flagstaff', :state => State.find_by_name('Arizona'), :country => Country.find_by_name('United States'))
    @acme.save!

    @amazon = Company.new(:name => "Amazon.com", :url => "http://www.amazon.com/", :industry => Industry.find_by_name('Retail'))
    @amazon.offices << Office.new(:city => 'Seattle', :state => State.find_by_name('Washington'), :country => Country.find_by_name('United States'))
    @amazon.save!

    @microsoft = Company.new(:name => "Microsoft", :url => "http://www.microsoft.com/", :industry => Industry.find_by_name('Technology'))
    @microsoft.offices << Office.new(:city => 'Redmond', :state => State.find_by_name('Washington'), :country => Country.find_by_name('United States'))
    @microsoft.save!

    @amazon_news = Post.create!(:title => 'Amazon.com IPO', :url => 'http://example.com/', :category => 'News', :body => 'Test', :user => User.find(:first), :company => @amazon)
  end
  
  # TODO: verify that the search returns the expected companies and posts
  def test_search
    get :index, :q => 'Amazon'
    assert_response :success
    assert_template 'searches/index'
    assert_equal(1, assigns(:companies).size)
    assert_equal(1, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_select 'h1', :text => /Search results matching Amazon/
    assert_valid_markup if should_validate_markup
  end

  def test_search_without_query
    get :index
    assert_response :success
    assert_template 'searches/index'
    assert_equal(0, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_select 'p', :text => /Couldn't parse query/
    assert_valid_markup if should_validate_markup
  end

  def test_search_with_empty_query
    get :index, :q => ''
    assert_response :success
    assert_template 'searches/index'
    assert_equal(0, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_select 'p', :text => /Your query is too short/
    assert_valid_markup if should_validate_markup
  end

  def test_search_with_short_query
    get :index, :q => 'x'
    assert_response :success
    assert_template 'searches/index'
    assert_equal(0, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_select 'p', :text => /Your query is too short/
    assert_valid_markup if should_validate_markup
  end
  
  def test_search_by_city
    get :index, :city => 'Seattle'
    assert_response :success
    assert_template 'searches/index'
    assert_equal(1, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_equal('Seattle', assigns(:companies).first.city)
    assert_select 'h1', :text => /Companies in Seattle/
    assert_valid_markup if should_validate_markup
  end
  
  def test_search_by_state
    get :index, :state => 'Washington'
    assert_response :success
    assert_template 'searches/index'
    assert_equal(2, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_equal('Washington', assigns(:companies).first.state_name)
    assert_select 'h1', :text => /Companies in Washington/
    assert_valid_markup if should_validate_markup
  end

  def test_search_by_city_and_state
    get :index, :city => 'Redmond', :state => 'Washington'
    assert_response :success
    assert_template 'searches/index'
    assert_equal(1, assigns(:companies).size)
    assert_equal(0, assigns(:news).size)
    assert_equal(0, assigns(:gossip).size)
    assert_equal(0, assigns(:questions).size)
    assert_equal('Redmond', assigns(:companies).first.city)
    assert_equal('Washington', assigns(:companies).first.state_name)
    assert_select 'h1', :text => /Companies in Redmond, Washington/
    assert_valid_markup if should_validate_markup
  end

end
