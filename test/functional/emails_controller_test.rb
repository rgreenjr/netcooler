require File.dirname(__FILE__) + '/../test_helper'
require 'emails_controller'

# Re-raise errors caught by the controller.
class EmailsController; def rescue_action(e) raise e end; end

class EmailsControllerTest < ActionMailer::TestCase

  fixtures  :companies, :posts, :users

  def setup
    @controller = EmailsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @post = posts(:apple_iphone_news)
    @bob = users(:bob)
    @form_data = { :post_id => @post, :email => { :subject => "Subject", :message => "Message", :recipients => "jdoe@example.com" } }
  end

  def test_email
    num_deliveries = ActionMailer::Base.deliveries.size
    login_as @bob
    get_email_form
    post :create, @form_data
    assert_response :success
    assert_template 'emails/create'
    assert_select 'h1', :text => /Email A Friend Complete/
    assert_select 'li', :text => /jdoe@example\.com/
    assert_equal(num_deliveries + 1, num_deliveries = ActionMailer::Base.deliveries.size)
    assert_valid_markup if should_validate_markup
  end

  def test_email_fails_withouts_login
    get :new, { :post_id => @post }
    assert_response :redirect
    assert_redirected_to new_session_url
  end

  def test_email_fails_with_no_subject
    login_as @bob
    get_email_form
    @form_data[:email][:subject] = ''
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Subject can't be blank/
  end

  def test_email_fails_with_subject_too_long
    login_as @bob
    get_email_form
    @form_data[:email][:subject] = "x" * 300
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Subject is too long \(maximum is 256 characters\)/
  end

  def test_email_fails_with_no_recipients
    login_as @bob
    get_email_form
    @form_data[:email][:recipients] = ''
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Recipient's email can't be blank/
  end

  def test_email_fails_with_invalid_recipients
    login_as @bob
    get_email_form
    @form_data[:email][:recipients] = 'jdoe@@@example.com'
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Recipient email 'jdoe@@@example.com' is invalid/
  end

  def test_email_fails_with_too_many_recipients
    login_as @bob
    get_email_form
    @form_data[:email][:recipients] = "foo1@bar.com, foo2@bar.com, foo3@bar.com, foo4@bar.com, foo5@bar.com, foo6@bar.com, foo7@bar.com"
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Recipient's email may contain up to 6 addresses/
  end

  def test_email_fails_with_message_too_long
    login_as @bob
    get_email_form
    @form_data[:email][:message] = "x" * 2050
    post :create, @form_data
    assert_response :success
    assert_select "li", :text => /Message is too long \(maximum is 2048 characters\)/
  end
  
  private
  
  def get_email_form
    get :new, { :post_id => @post }
    assert_response :success
    assert_select "h1", :text => /Email A Friend/
  end

end
