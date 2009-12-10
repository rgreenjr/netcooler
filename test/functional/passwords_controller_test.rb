require File.dirname(__FILE__) + '/../test_helper'
require 'passwords_controller'
require 'feed_validator/assertions'

# Re-raise errors caught by the controller.
class PasswordsController; def rescue_action(e) raise e end; end

class PasswordsControllerTest < ActionController::TestCase

  include Arts

  fixtures :users

  def setup
    super
    @controller = PasswordsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @bob = users(:bob)
    @update_password_data = { :user => { :password => 'secret', :password_confirmation => 'secret' }, :_method => :put }
  end

  def test_update_password
    num_deliveries = ActionMailer::Base.deliveries.size
    login_as @bob
    post :update, @update_password_data
    @bob.reload
    assert_equal User.hash_password('secret'), @bob.password_hash
    assert_equal(num_deliveries + 1, num_deliveries = ActionMailer::Base.deliveries.size)
  end

  def test_update_password_fails_without_login
    post :update, @update_password_data
    assert_redirected_to new_session_url
  end

  def test_update_password_fails_on_incorrect_confirmation
    login_as @bob
    original_password = @bob.password_hash
    @update_password_data[:user][:password_confirmation] = 'not_secret'
    post :update, @update_password_data
    assert_select "li", :text => /Password doesn't match confirmation/
    @bob.reload
    assert_equal @bob.password_hash, original_password
  end

  def test_reset_password
    num_deliveries = ActionMailer::Base.deliveries.size
    original_password = @bob.password_hash
    post :create, { :email => @bob.email }
    assert_equal "An email with your new password has been sent to #{@bob.email}.", flash[:notice]
    assert_redirected_to new_session_url
    @bob.reload
    assert @bob.password_hash != original_password
    assert_equal(num_deliveries + 1, num_deliveries = ActionMailer::Base.deliveries.size)
  end

  def test_reset_password_fails_on_unknown_email
    post :create, { :email => 'xxxx@example.com' }
    assert_select "p", :text => /A user with that email address could not be found/
  end

end