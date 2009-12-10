require File.dirname(__FILE__) + '/../test_helper'
require 'email_notifier'

class EmailNotifierTest < ActionMailer::TestCase
  
  def setup
    @bob = User.create!(:first_name => 'Bob', :last_name => 'Smith', :username => 'bsmith',  :email => 'bsmith@example.com',   :password => 'pass', :password_confirmation => 'pass')
    @dave = User.create!(:first_name => 'Dave', :last_name => 'Taylor', :username => 'dtaylor',  :email => 'dtaylor@example.com',   :password => 'pass', :password_confirmation => 'pass')
    @acme = Company.create!(:name => 'Acme, Inc', :url => 'http://www.acme.com/', :industry => Industry.find(:first))
    @post = Post.create!(:user => @dave, :company => @acme, :category => 'News', :title => 'title', :url => "http://www.example.com/", :body => 'body')
  end

  def test_registration
    response = EmailNotifier.deliver_registration(@bob)
    assert_equal('Welcome to Netcooler', response.subject)
    assert_equal(@bob.email, response.to.first)
    assert_match(/Welcome to Netcooler bsmith/, response.body)
    assert_match(/Thanks for becoming the newest member of the Netcooler community/, response.body)
  end 

  def test_change_password
    response = EmailNotifier.deliver_change_password(@bob)
    assert_equal('Netcooler Password Change', response.subject)
    assert_equal(@bob.email, response.to.first)
    assert_match(/bsmith/, response.body)
    assert_match(/This is confirmation that your password has been changed successfully/, response.body)
  end 

  def test_reset_password
    response = EmailNotifier.deliver_reset_password(@bob)
    assert_equal('Netcooler Password Reset', response.subject)
    assert_equal(@bob.email, response.to.first)
    assert_match(/Your Netcooler password has been successfully reset/, response.body)
    # assert_match(/#{new_session_url}/, response.body)
  end 

  def test_email_friend
    response = EmailNotifier.deliver_email_friend(@dave, @bob.email, 'subject', 'message', @post, 'xxx')
    assert_equal('subject', response.subject)
    assert_equal(@bob.email, response.to.first)
    assert_match(/Message from dtaylor/, response.body)
    assert_match(/thought you would be interested in a posting at Netcooler about/, response.body)
  end 

  private

  def encode(subject)
    quoted_printable(subject, "utf-8")
  end

end
