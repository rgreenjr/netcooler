require File.dirname(__FILE__) + '/../test_helper'
require 'companies_controller'
require 'feed_validator/assertions'

# Re-raise errors caught by the controller.
class CompaniesController; def rescue_action(e) raise e end; end

class CompaniesControllerTest < ActionController::TestCase

  fixtures :companies, :users, :industries, :states, :countries

  def setup
    super
    @bob = users(:bob)
    @apple = companies(:apple)
    @technology = industries(:technology)
    @new_york = states(:new_york)
    @usa = countries(:usa)
    @company_data = {
      :company => {:name => "ACME, Inc.", :url => "http://www.acme.com/", :domain => "acme.com", :industry_id => @technology}, 
      :office  => {:street1 => "101 Main Street", :street2 => "Suite 4000", :city => "New York", :state_id => @new_york.id, :zip => 78726, :country_id => @usa.id}
    }    
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_index_with_industry
    get :index, :industry_id => 1
    assert_response :success
    assert_kind_of Industry, assigns(:industry) 
    assert_equal 1, assigns(:industry).id 
    assert_valid_markup if should_validate_markup
  end

  def test_show
    get :show, :id => @apple.id
    assert_response :success
    assert_template 'companies/show'
    assert_kind_of Company, assigns(:company) 
    assert_equal @apple.id, assigns(:company).id 
  end

  def test_show_with_format_atom
    get :show, :id => @apple.id, :format => 'atom'
    assert_response :success
    assert_template 'companies/show'
    assert_select "title", "Netcooler - #{@apple.name}"
    # puts @response.body
    assert_valid_feed
  end
  
  def test_new
    login_as @bob
    get :new
    assert_response :success
    assert_valid_markup if should_validate_markup
  end

  def test_create
    login_as @bob
    post :create, @company_data
    assert_response :redirect
    acme = Company.find_by_domain("acme.com")
    assert_not_nil acme
    assert_redirected_to company_url(acme)
  end

  def test_create_fails_without_attributes
    login_as @bob
    post :create, {:office  => {:country_id => @usa.id}}
    assert_response :success
    assert_template 'companies/new'
  end

  def test_create_fails_with_invalid_company
    login_as @bob
    @company_data[:company][:name] = ''
    @company_data[:company][:url] = ''
    @company_data[:company][:industry_id] = ''
    post :create, @company_data
    assert_response :success
    assert_template 'companies/new'
    assert_select "li", :text => /Name can't be blank/
    assert_select "li", :text => /Url is invalid/
    assert_select "li", :text => /Industry can't be blank/
  end

  def test_create_fails_with_invalid_office
    login_as @bob
    @company_data[:office][:city] = nil
    @company_data[:office][:state_id] = nil
    post :create, @company_data
    assert_response :success
    assert_template 'companies/new'
    assert_select "li", :text => /State can't be blank/
    assert_select "li", :text => /City can't be blank/
  end

  def test_create_fails_without_login
    post :create, @company_data
    assert_response :redirect
    assert_redirected_to new_session_url
  end
  
end
