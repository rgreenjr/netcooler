require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < ActionController::TestCase
  
  fixtures :companies, :users, :posts, :comments
  
  def setup
    super
    @bob = users(:bob)
    @dave = users(:dave)
    @sally = users(:sally)
    @apple = companies(:apple)
    @post = posts(:apple_iphone_news)
    @comment = @post.comments.first
    @create_data = { :comment => { :body => "This is a test comment." }, :post_id => @post }
    @update_data = { :comment => { :body => "This is a test comment." }, :id => @comment, :_method => :put }  
  end

  def test_index
    get :index, :user_id => @bob.username
    assert_response :success
    assert_select "h1", :text => /1 Comment by bobjones/
    # puts @response.body
    assert_valid_markup if should_validate_markup
  end

  def test_create
    login_as(@bob)
    count = @post.comments.count
    post :create, @create_data
    assert_redirected_to post_url(@post)
    assert_equal(count + 1, @post.comments.count)
  end

  def test_create_fails_with_empty_body
    login_as(@bob)
    count = @post.comments.count
    @create_data[:comment][:body] = ''
    post :create, @create_data
    assert_redirected_to post_url(@post) + '#add-comment'
    @post.reload
    assert_equal(count, @post.comments.count)
  end

  def test_create_fails_on_body_too_long
    login_as(@bob)
    count = @post.comments.count
    @create_data[:comment][:body] = 'x' * 2050
    post :create, @create_data
    assert_redirected_to post_url(@post) + '#add-comment'
    @post.reload
    assert_equal(count, @post.comments.count)
  end

  def test_create_fails_wihtout_login
    count = @post.comments.count
    post :create, @create_data
    assert_redirected_to new_session_url
    assert_equal(count, @post.comments.count)
  end
  
  def test_edit
    login_as @comment.user
    get :edit, :id => @comment.id
    assert_response :success
    assert_kind_of Comment, assigns(:comment) 
    assert_equal(@comment.id, assigns(:comment).id)
    assert_valid_markup if should_validate_markup
  end

  def test_update
    login_as @comment.user
    post :update, @update_data
    assert_response :redirect
    assert_redirected_to :action => 'show'
    @comment.reload
    assert_equal(@update_data[:comment][:body], @comment.body)
  end

  def test_update_fails_on_empty_body
    login_as @comment.user
    @update_data[:comment][:body] = ''
    post :update, @update_data
    assert_response :success
    assert_select "li", :text => /Body can't be blank/
    # puts @response.body
    # assert_valid_markup if should_validate_markup
  end

  def test_update_fails_on_body_too_long
    login_as @comment.user
    @update_data[:comment][:body] = 'x' * 2050
    post :update, @update_data
    assert_response :success
    assert_select "li", :text => /Body is too long \(maximum is 2048 characters\)/
  end

  def test_update_fails_unless_author
    login_as @sally
    assert !@sally.admin?
    assert_not_equal(@sally, @comment.user)
    post :update, @update_data
    assert_response :success
    assert_select "p", :text => /You may only edit your own posts/
  end

  def test_update_allowed_as_admin
    login_as @dave
    assert @dave.admin?
    assert_not_equal(@dave, @comment.user)
    post :update, @update_data
    assert_response :redirect
    assert_redirected_to :action => 'show'
    @comment.reload
    assert_equal(@update_data[:comment][:body], @comment.body)
  end
  
end
