require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

# Re-raise errors caught by the controller.
class PostsController; def rescue_action(e) raise e end; end

class PostsControllerTest < ActionController::TestCase
  
  fixtures  :companies, :posts, :users

  def setup
    super
    @apple = companies(:apple)
    @post = posts(:apple_iphone_news)
    @bob = users(:bob)
    @dave = users(:dave)
    @create_data = { 
      :company_id => @apple.id, :category => 'News', 
      :post => { :title => 'title', :body => 'body', :url => 'http://example.com/', :category => 'News', :tag_string => "aa bb cc dd ee" }
    }
    @update_data = { 
      :id => @post.id, :_method => :put, 
      :post => { :title => 'new_title', :body => 'new_body', :url => 'http://new.example.com/', :tag_string => 'new tag' }
    }
    @rate_data = { :id => @post.id, :value => 1 }
  end

  def test_index
    e = assert_raise(ArgumentError) { get :index }
    assert_match(/Must specify either company_id or user_id/i, e.message)
  end

  def test_index_with_company
    get :index, :company_id => @apple.id, :category => 'news'
    assert_response :success
    assert_kind_of Company, assigns(:company) 
    assert_equal @apple.id, assigns(:company).id 
    assert_valid_markup if should_validate_markup
  end

  def test_index_with_user
    get :index, :user_id => @bob.username
    assert_response :success
    assert_kind_of User, assigns(:user) 
    assert_equal @bob.id, assigns(:user).id 
    assert_valid_markup if should_validate_markup
  end

  def test_index_with_user_and_category
    get :index, :user_id => @bob.username, :category => 'news'
    assert_response :success
    assert_kind_of User, assigns(:user) 
    assert_equal @bob.id, assigns(:user).id 
    assert_valid_markup if should_validate_markup
  end

  def test_show
    get :show, :id => @post.id
    assert_response :success
    assert_kind_of Post, assigns(:post) 
    assert_equal @post.id, assigns(:post).id 
    assert_valid_markup if should_validate_markup
  end
  
  def test_new
    login_as @bob
    get :new, :company_id => @apple.id
    assert_response :success
    assert_kind_of Post, assigns(:post) 
    # assert_valid_markup if should_validate_markup
  end
    
  def test_create
    login_as @bob
    count = @apple.posts.count
    post :create, @create_data
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal count + 1, @apple.posts.count
    assert_equal @create_data[:post][:tag_string], @apple.posts.last.tag_string
  end
  
  def test_create_fails_without_login
    count = @apple.posts.count
    post :create, @create_data
    assert_redirected_to new_session_url
    assert_equal count, @apple.posts.count
  end
  
  def test_create_fails_on_invalid_title
    login_as @bob
    count = @apple.posts.count
    @create_data[:post][:title] = ''
    post :create, @create_data
    assert_select "li", :text => /Title can't be blank/
    assert_equal count, @apple.posts.count
  end
  
  def test_create_fails_on_invalid_url
    login_as @bob
    count = @apple.posts.count
    @create_data[:post][:url] = ''
    post :create, @create_data
    assert_select "li", :text => /Url is invalid/
    assert_equal count, @apple.posts.count
  end
  
  def test_create_fails_on_invalid_body
    login_as @bob
    count = @apple.posts.count
    @create_data[:post][:body] = ''
    post :create, @create_data
    assert_select "li", :text => /Body can't be blank/
    assert_equal count, @apple.posts.count
  end
  
  def test_edit
    login_as @post.user
    get :edit, :id => @post.id
    assert_response :success
    assert_kind_of Post, assigns(:post)
    assert_equal(@post.id, assigns(:post).id)
    # assert_valid_markup if should_validate_markup
  end
  
  def test_update
    login_as @post.user
    post :update, @update_data
    assert_response :redirect
    assert_redirected_to :action => 'show'
    @post.reload
    assert_equal @update_data[:post][:url], @post.url
    assert_equal @update_data[:post][:body], @post.body
    assert_equal @update_data[:post][:title], @post.title
    assert_equal @update_data[:post][:tag_string], @post.tag_string
  end
  
  def test_update_fails_without_login
    post :update, @update_data
    assert_redirected_to new_session_url
  end  
  
  def test_update_fails_when_not_author
    login_as @bob
    assert @bob != @post.user
    post :update, @update_data
    assert_select "p", :text => /You may only edit your own posts/
  end
  
  def test_update_allowed_when_admin
    login_as @dave
    assert @dave.admin?
    assert @dave != @post.user
    post :update, @update_data
    assert_response :redirect
    assert_redirected_to :action => 'show'
    @post.reload
    assert_equal @update_data[:post][:url], @post.url
    assert_equal @update_data[:post][:body], @post.body
    assert_equal @update_data[:post][:title], @post.title
    assert_equal @update_data[:post][:tag_string], @post.tag_string
  end
  
  def test_update_fails_on_invalid_title
    login_as @post.user
    count = @apple.posts.count
    @update_data[:post][:title] = ''
    post :update, @update_data
    assert_select "li", :text => /Title can't be blank/
    assert_equal count, @apple.posts.count
  end
  
  def test_update_fails_on_invalid_url
    login_as @post.user
    count = @apple.posts.count
    @update_data[:post][:url] = ''
    post :update, @update_data
    assert_select "li", :text => /Url is invalid/
    assert_equal count, @apple.posts.count
  end
  
  def test_update_fails_on_invalid_body
    login_as @post.user
    count = @apple.posts.count
    @update_data[:post][:body] = ''
    post :update, @update_data
    assert_select "li", :text => /Body can't be blank/
    assert_equal count, @apple.posts.count
  end
  
  def test_update_fails_on_invalid_tag
    login_as @post.user
    count = @apple.posts.count
    @update_data[:post][:tag_string] = 'a'
    post :update, @update_data
    assert_select "li", "Tag 'a' is too short (minimum is 2 characters)"
    assert_equal count, @apple.posts.count
  end
  
  # tests for changing post status

  def test_update_status_as_approved
    login_as @dave
    assert @dave.admin?
    put :update, :id => @post.id, :_method => :put, :post => { :status => 'Approved' }
    assert_response :redirect
    @post.reload
    assert_equal("Approved", @post.status)
  end

  def test_update_status_as_blocked
    login_as @dave
    assert @dave.admin?
    put :update, :id => @post.id, :_method => :put, :post => { :status => 'Blocked' }
    assert_response :redirect
    @post.reload
    assert_equal("Blocked", @post.status)
  end

  def test_update_status_redirects_when_not_admin
    login_as @bob
    assert !@bob.admin?
    put :update, :id => @post.id, :_method => :put, :post => { :status => 'Approved' }
    assert_template 'edit'
    assert_select "p", :text => /You may only edit your own posts/
  end

  def test_update_status_fails_when_status_invalid
    assert_equal("Approved", @post.status)
    login_as @dave
    assert @dave.admin?
    put :update, :id => @post.id, :_method => :put, :post => { :status => 'XXXXXX' }
    assert_template 'edit'
    assert_select "li", :text => /Status is not included in the list/
    @post.reload
    assert_equal("Approved", @post.status)
  end
  
  # atom feed tests
  
  def test_valid_news_feed
    get :index, :company_id => @apple.id, :format => 'atom', :category => 'news'
    assert_response :success
    assert_template 'posts/index.atom.builder'
    assert_select "title", "Netcooler - #{@apple.name} - News"
  end
  
  def test_valid_gossip_feed
    get :index, :company_id => @apple.id, :format => 'atom', :category => 'gossip'
    assert_response :success
    assert_template 'posts/index.atom.builder'
    assert_select "title", "Netcooler - #{@apple.name} - Gossip"
  end
  
  def test_valid_question_feed
    get :index, :company_id => @apple.id, :format => 'atom', :category => 'questions'
    assert_response :success
    assert_template 'posts/index.atom.builder'
    assert_select "title", "Netcooler - #{@apple.name} - Questions"
  end
  
end
