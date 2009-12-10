require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'
require 'feed_validator/assertions'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  include Arts

  fixtures :users

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @bob = users(:bob)
    @bob_password = 'pass'
    @dave = users(:dave)
    @sally = users(:sally)
    @create_data = { :user => { :username => 'jsmith', :first_name => 'John', :last_name => 'Smith', :email => 'jsmith@example.com', :password => 'pass' } }
    @update_data = { :user => { :username=>'newusername', :first_name=>'new_first_name', :last_name=>'new_last_name', :email=>'new_email@example.com'}, :_method => :put, :id => @bob.username }
    @update_password_data = { :user => { :password => 'secret', :password_confirmation => 'secret' }, :_method => :put, :id => @bob.username }
  end
  
  def test_index_succeeds_when_admin
    login_as @dave
    assert @dave.admin?
    get :index
    assert_response :success
    assert_template 'users/index'
    assert_valid_markup if should_validate_markup
  end

  def test_index_redirects_when_not_admin
    login_as @bob
    assert !@bob.admin?
    get :index
    assert_redirected_to root_url 
  end
  
  def test_show
    get :show, :id => @bob.username
    assert_response :success
    assert_kind_of User, assigns(:user) 
    assert_equal @bob.id, assigns(:user).id 
    assert_equal @bob.username, assigns(:user).username
    assert_valid_markup if should_validate_markup
  end

  def test_create
    num_deliveries = ActionMailer::Base.deliveries.size
    post :create, @create_data
    assert_response :redirect
    assert_redirected_to root_url
    assert_equal(num_deliveries + 1, num_deliveries = ActionMailer::Base.deliveries.size)
  end

  def test_create_fails_on_invalid_attributes
    post :create, :user => {}
    assert_response :success
    assert_template 'users/new'
    assert_select "li", :text => /Username is too short \(minimum is 2 characters\)/
  end
  
  def test_edit
    login_as @bob
    get :edit, :id => @bob.username
    assert_response :success
    assert_kind_of User, assigns(:user) 
    # puts @response.body
    # assert_valid_markup if should_validate_markup
  end

  def test_update
    login_as @bob
    post :update, @update_data
    assert_select "p", :text => /Your profile was successfully updated/
    @bob.reload
    assert_equal @update_data[:user][:username], @bob.username
    assert_equal @update_data[:user][:first_name], @bob.first_name
    assert_equal @update_data[:user][:last_name], @bob.last_name
    assert_equal @update_data[:user][:email], @bob.email
  end

  def test_update_fails_without_login
    post :update, @update_data
    assert_redirected_to new_session_url
  end

  def test_update_fails_on_bad_email
    login_as @bob
    @update_data[:user][:email] = 'x@@x.com'
    post :update, @update_data
    assert_select "li", :text => /Email is invalid/
  end

  def test_update_fails_on_bad_username
    login_as @bob
    @update_data[:user][:username] = 'x'
    post :update, @update_data
    assert_select "li", :text => /Username is too short \(minimum is 2 characters\)/
  end

  def test_check_username_not_available_with_used_name
    xhr :post, :check_username, :username => @bob.username
    assert_response :success
    assert_template 'users/check_username'
    assert_equal false, assigns(:available)
    assert_rjs :show, 'username_status'
    assert_rjs :replace_html, :username_status, "<span style='color: red;'>Not Available</span>"
  end
  
  def test_check_username_available_with_unused_name
    xhr :post, :check_username, :username => 'jdoe'
    assert_response :success
    assert_template 'users/check_username'
    assert_equal true, assigns(:available)
    assert_rjs :show, 'username_status'
    assert_rjs :replace_html, :username_status, "<span style='color: green;'>Available</span>"
  end
  
  def test_update_admin
    assert @dave.admin?
    login_as @dave
    
    assert !@bob.admin?
    post :update, { :id => @bob.username, :_method => "put", :user => { :admin => "true" } }
    assert_response :success
    assert_select "p", :text => /Your profile was successfully updated/
    @bob.reload
    
    assert @bob.admin?
    post :update, { :id => @bob.username, :_method => "put", :user => { :admin => "false" } }
    assert_response :success
    assert_select "p", :text => /Your profile was successfully updated/
    @bob.reload
    assert !@bob.admin?
  end
  
  def test_update_admin_fails_unless_admin
    assert !@bob.admin?
    login_as @bob
    assert @dave.admin?
    post :update, { :id => @dave.username, :_method => "put", :user => { :admin => "false" } }
    assert_redirected_to user_url(@bob)
    @dave.reload
    assert @dave.admin?
  end
  
  def test_update_status
    assert @dave.admin?
    login_as @dave

    assert !@bob.blocked?
    post :update, { :id => @bob.username, :_method => "put", :user => { :status => "Blocked" } }
    assert_response :success
    assert_select "p", :text => /Your profile was successfully updated/
    @bob.reload
    assert @bob.blocked?
    
    post :update, { :id => @bob.username, :_method => "put", :user => { :status => "Registered" } }
    assert_response :success
    assert_select "p", :text => /Your profile was successfully updated/
    @bob.reload
    assert !@bob.blocked?
  end
  
  def test_update_status_fails_unless_admin
    assert !@sally.admin?
    login_as @sally

    assert !@bob.blocked?
    post :update, { :id => @bob.username, :_method => "put", :user => { :status => "Blocked" } }
    assert_redirected_to user_url(@sally)
    @bob.reload
    assert !@bob.blocked?
    
    post :update, { :id => @bob.username, :_method => "put", :user => { :status => "Registered" } }
    assert_redirected_to user_url(@sally)
    @bob.reload
    assert !@bob.blocked?
  end
  
end
