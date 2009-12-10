require "#{File.dirname(__FILE__)}/../test_helper"

class UserSessionTest < ActionController::IntegrationTest  

  def test_registering_new_person
    go_to_login
    go_to_registration
    register :user => { :username => 'jsmith', :first_name => 'John', :last_name => 'Smith', :email => 'jsmith@example.com', :password => 'pass' }
  end

  private

  def go_to_login
    get new_session_url
    assert_response :success
    assert_template "sessions/new"
  end

  def go_to_registration
    get new_user_url
    assert_response :success
    assert_template "users/new"
  end

  def register(options)
    post users_url, options
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "index"
  end
        
end