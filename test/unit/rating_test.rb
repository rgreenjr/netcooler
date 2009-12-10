require File.dirname(__FILE__) + '/../test_helper'

class RatingTest < Test::Unit::TestCase
  
  fixtures :users, :posts, :comments
  
  def setup
    @bob = users(:bob)
    @sally = users(:sally)
    @jack = users(:jack)
    @post = posts(:apple_iphone_news)
    @comment = comments(:first_news_comment)
  end

  def test_valid_with_attributes
    rating = Rating.new(:user => @bob, :value => 1, :rateable => @post)
    assert rating.valid?
  end
  
  def test_invalid_without_attributes
    rating = Rating.new
    assert !rating.valid?
    assert rating.errors.invalid?(:value)
    assert_equal "should be 1 or -1", rating.errors[:value]
    assert rating.errors.invalid?(:user)
    assert_equal "does not exist", rating.errors[:user]
    assert rating.errors.invalid?(:rateable)
    assert_equal "does not exist", rating.errors[:rateable]
  end
  
  def test_valid_values
    [-1, 1].each do |value|
      rating = Rating.new(:user => @bob, :value => value)
      assert @post.ratings << rating
      assert rating.valid?
      assert !rating.errors.invalid?(:value)
    end
  end

  def test_invalid_values
    ['a', '', 0, 100].each do |value|
      rating = Rating.new(:user => @bob, :value => value)
      assert !rating.valid?
      assert rating.errors.invalid?(:value)
      assert_equal "should be 1 or -1", rating.errors[:value]
    end
  end
  
  def test_cool
    rating = Rating.new(:user => @bob, :value => 1, :rateable => @post)
    assert_equal(true, rating.cool?)
  end

  def test_uncool
    rating = Rating.new(:user => @bob, :value => -1, :rateable => @post)
    assert_equal(true, rating.uncool?)
  end

end