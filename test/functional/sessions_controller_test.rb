require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
  
  def setup
    super
    @roger = User.create!(:first_name => 'Roger', :last_name => 'Moore', :username => 'rmoore', :email => 'rmoore@example.com', :password => 'pass')
  end

  def test_create
    post :create, { :username => @roger.username, :password => 'pass' }
    assert_response :redirect
    assert_equal(@roger.id, session[:user_id])
  end

  def test_create_wrong_username
    post :create, { :username => 'wrong', :password => 'pass' }
    assert_select "p", :text => /Invalid username and password combination/
  end

  def test_create_wrong_password
    post :create, { :username => @roger.username, :password => 'wrong' }
    assert_select "p", :text => /Invalid username and password combination/
  end

  def test_destroy
    delete :destroy
    assert_response :redirect
  end
  
end
