require File.dirname(__FILE__) + '/../test_helper'
require 'post_ratings_controller'

# Re-raise errors caught by the controller.
class PostRatingsController; def rescue_action(e) raise e end; end

class PostRatingsControllerTest < ActionController::TestCase

  fixtures  :companies, :posts, :users

  def setup
    super
    @apple = companies(:apple)
    @news = posts(:apple_iphone_news)
    @bob = users(:bob)
    @dave = users(:dave)
    @rate_data = { :post_id => @news.id, :value => 1 }
  end

  def test_rating
    login_as @bob
    count = @news.ratings.size
    post :create, @rate_data
    @news.reload
    assert_equal(count + 1, @news.ratings.size)
    assert_equal(@bob, @news.ratings.last.user)
    assert_equal(1, @news.ratings.last.value)
  end
  
  def test_rating
    login_as @bob
    count = @news.ratings.size
    xhr :post, :create, @rate_data
    @news.reload
    assert_equal(count + 1, @news.ratings.size)
    assert_equal(@bob, @news.ratings.last.user)
    assert_equal(1, @news.ratings.last.value)
  end
  
  def test_rating_change
    login_as @bob
    count = @news.ratings.size
    post :create, @rate_data
    @news.reload
    assert_equal(count + 1, @news.ratings.size)
    assert_equal(@bob, @news.ratings.last.user)
    assert_equal(1, @news.ratings.last.value)
    # now change the rating to negative
    count = @news.ratings.size
    @rate_data[:value] = -1
    post :create, @rate_data
    @news.reload
    assert_equal(count, @news.ratings.size)
    assert_equal(@bob, @news.ratings.last.user)
    assert_equal(-1, @news.ratings.last.value)
  end
  
  def test_rating_delete
    login_as @bob
    count = @news.ratings.size
    post :create, @rate_data
    @news.reload
    assert_equal(count + 1, @news.ratings.size)
    assert_equal(@bob, @news.ratings.last.user)
    assert_equal(1, @news.ratings.last.value)
    # now rate again with the same value to undo (delete) the rating
    count = @news.ratings.size
    post :create, @rate_data
    @news.reload
    assert_equal(count - 1, @news.ratings.size)
  end
  
  def test_rating_fails_without_login
    count = @news.ratings.size
    post :create, @rate_data
    assert_redirected_to new_session_url
    @news.reload
    assert_equal(count, @news.ratings.size)
  end
  
  def test_rating_fails_with_invalid_value
    login_as @bob
    count = @news.ratings.size
    @rate_data[:value] = 'x'
    e = assert_raise(ArgumentError) { post :create, @rate_data }
    assert_match(/Illegal value/i, e.message)
    @news.reload
    assert_equal(count, @news.ratings.size)
  end    

end
