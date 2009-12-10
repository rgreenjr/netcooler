require File.dirname(__FILE__) + '/../test_helper'
require 'comment_ratings_controller'

# Re-raise errors caught by the controller.
class CommentRatingsController; def rescue_action(e) raise e end; end

class CommentRatingsControllerTest < ActionController::TestCase

  fixtures  :posts, :users, :comments

  def setup
    super
    @comment = comments(:first_news_comment)
    @bob = users(:bob)
    @dave = users(:dave)
    @rate_data = { :comment_id => @comment.id, :value => 1 }
  end

  def test_rating
    login_as @bob
    count = @comment.ratings.size
    post :create, @rate_data
    @comment.reload
    assert_equal(count + 1, @comment.ratings.size)
    assert_equal(@bob, @comment.ratings.last.user)
    assert_equal(1, @comment.ratings.last.value)
  end
  
  def test_rating_with_xhr
    login_as @bob
    count = @comment.ratings.size
    xhr :post, :create, @rate_data
    @comment.reload
    assert_equal(count + 1, @comment.ratings.size)
    assert_equal(@bob, @comment.ratings.last.user)
    assert_equal(1, @comment.ratings.last.value)
  end
  
  def test_rating_change
    login_as @bob
    count = @comment.ratings.size
    post :create, @rate_data
    @comment.reload
    assert_equal(count + 1, @comment.ratings.size)
    assert_equal(@bob, @comment.ratings.last.user)
    assert_equal(1, @comment.ratings.last.value)
    # now change the rating to negative
    count = @comment.ratings.size
    @rate_data[:value] = -1
    post :create, @rate_data
    @comment.reload
    assert_equal(count, @comment.ratings.size)
    assert_equal(@bob, @comment.ratings.last.user)
    assert_equal(-1, @comment.ratings.last.value)
  end
  
  def test_rating_delete
    login_as @bob
    count = @comment.ratings.size
    post :create, @rate_data
    @comment.reload
    assert_equal(count + 1, @comment.ratings.size)
    assert_equal(@bob, @comment.ratings.last.user)
    assert_equal(1, @comment.ratings.last.value)
    # now rate again with the same value to undo (delete) the rating
    count = @comment.ratings.size
    post :create, @rate_data
    @comment.reload
    assert_equal(count - 1, @comment.ratings.size)
  end
  
  def test_rating_fails_without_login
    count = @comment.ratings.size
    post :create, @rate_data
    assert_redirected_to new_session_url
    @comment.reload
    assert_equal(count, @comment.ratings.size)
  end
  
  def test_rating_fails_with_invalid_value
    login_as @bob
    count = @comment.ratings.size
    @rate_data[:value] = 'x'
    e = assert_raise(ArgumentError) { post :create, @rate_data }
    assert_match(/Illegal value/i, e.message)
    @comment.reload
    assert_equal(count, @comment.ratings.size)
  end    

end
