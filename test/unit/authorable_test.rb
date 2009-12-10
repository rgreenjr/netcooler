require File.dirname(__FILE__) + '/../test_helper'

class AuthorableTest < Test::Unit::TestCase
    
  fixtures :industries

  def setup
    @acme = Company.create!(:name => 'Acme, Inc', :url => 'http://www.acme.com/', :industry => Industry.find(:first))
    @bob = User.create!(:first_name => 'Bob', :last_name => 'Smith', :username => 'bsmith', :email => 'bsmith@example.com', :password => 'pass', :password_confirmation => 'pass')
    @sally = User.create!(:first_name => 'Sally', :last_name => 'Smith', :username => 'ssmith', :email => 'ssmith@example.com', :password => 'pass', :password_confirmation => 'pass')
    @dave = User.create!(:first_name => 'Dave', :last_name => 'Taylor', :username => 'dtaylor', :email => 'dtaylor@example.com', :password => 'pass', :password_confirmation => 'pass', :admin => true)
    @post = Post.create!(:user => @sally, :company => @acme, :category => 'News', :title => 'title', :url => "http://www.example.com/", :body => 'body')
    @old_post = Post.create!(:user => @sally, :company => @acme, :category => 'Question', :title => 'title', :url => "http://www.example.com/", :body => 'body', :created_at => 2.hours.ago)
  end

  def test_user_can_edit_own_posts
    assert !@sally.admin?
    assert @post.author?(@sally)
    assert @post.editable_by?(@sally)
  end
  
  def test_user_cannot_edit_others_posts
    assert !@bob.admin?
    assert !@post.author?(@bob)
    assert !@post.editable_by?(@bob)
  end
  
  def test_admin_can_edit_any_post
    assert @dave.admin?
    assert !@post.author?(@dave)
    assert @post.editable_by?(@dave)
  end
  
  def test_user_cannot_edit_old_posts
    assert !@sally.admin?
    assert @old_post.author?(@sally)
    assert !@old_post.fresh?
    assert !@old_post.editable_by?(@sally)
  end
  
end
