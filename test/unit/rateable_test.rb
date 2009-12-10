require File.dirname(__FILE__) + '/../test_helper'

class RateableTest < Test::Unit::TestCase
  
  fixtures :users, :posts

  def setup
    @bob = users(:bob)
    @dave = users(:dave)
    @sally = users(:sally)
    @jack = users(:jack)
    @post = posts(:apple_iphone_news)
  end

  def test_user_rating
    assert @post.rate(@bob, 1)
    assert_equal(1, @post.coolness)
    # rating = post.user_rating(@bob)
    # assert_equal(@bob, rating.user)
  end

  def test_coolness
    assert @post.rate(@bob, 1)
    assert_equal(1, @post.coolness)
    
    assert @post.rate(@sally, 1)
    assert_equal(2, @post.coolness)
    
    assert @post.rate(@jack, -1)
    assert_equal(1, @post.coolness)
    
    assert @post.rate(@dave, -1)
    assert_equal(0, @post.coolness)
    
    assert @post.rate(@bob, -1)
    assert_equal(-2, @post.coolness)
    
    assert @post.rate(@sally, -1)
    assert_equal(-4, @post.coolness)
  end

  def test_cools_and_uncools
    assert @post.rate(@bob, 1)
    assert_equal(1, @post.cools)
    assert_equal(0, @post.uncools)

    assert @post.rate(@sally, 1)
    assert_equal(2, @post.cools)
    assert_equal(0, @post.uncools)

    assert @post.rate(@jack, -1)
    assert_equal(2, @post.cools)
    assert_equal(1, @post.uncools)

    assert @post.rate(@dave, -1)
    assert_equal(2, @post.cools)
    assert_equal(2, @post.uncools)

    assert @post.rate(@bob, -1)
    assert_equal(1, @post.cools)
    assert_equal(3, @post.uncools)
    
    assert @post.rate(@sally, -1)
    assert_equal(0, @post.cools)
    assert_equal(4, @post.uncools)
  end

  def test_cool_and_uncool_percentages
    assert @post.rate(@bob, 1)
    assert_equal(100.0, @post.cool_percentage)
    assert_equal(0.0, @post.uncool_percentage)

    assert @post.rate(@sally, 1)
    assert_equal(100.0, @post.cool_percentage)
    assert_equal(0.0, @post.uncool_percentage)

    assert @post.rate(@jack, -1)
    assert_in_delta(66.66, @post.cool_percentage, 0.01)
    assert_in_delta(33.33, @post.uncool_percentage, 0.01)

    assert @post.rate(@dave, -1)
    assert_equal(50.0, @post.cool_percentage)
    assert_equal(50.0, @post.uncool_percentage)

    assert @post.rate(@bob, -1)
    assert_equal(25.0, @post.cool_percentage)
    assert_equal(75.0, @post.uncool_percentage)
    
    assert @post.rate(@sally, -1)
    assert_equal(0.0, @post.cool_percentage)
    assert_equal(100.0, @post.uncool_percentage)
  end
  
  def test_invalid_rating_raises_exception
    e = assert_raise(ArgumentError) { @post.rate(@bob, 5) }
    assert_match(/Illegal value/i, e.message)
    e = assert_raise(ArgumentError) { @post.rate(@bob, 'x') }
    assert_match(/Illegal value/i, e.message)
  end

  # def test_find_highest_rated
  #   @apple_iphone_news = posts(:apple_iphone_news)
  #   @google_ipo_news = posts(:google_ipo_news)
  #   @dell_printer_gossip = posts(:dell_printer_gossip)
  #   
  #   # 3 cool 0 uncool for @apple_iphone_news
  #   [@bob, @dave, @sally, @jack].each { |user| @apple_iphone_news.rate(user, 1) }
  #   assert_equal(4, @apple_iphone_news.coolness)
  #   
  #   # 3 cool 1 uncool for @google_ipo_news
  #   [@bob, @dave, @sally].each { |user| @google_ipo_news.rate(user, 1) }
  #   [@jack].each { |user| @google_ipo_news.rate(user, -1) }
  #   assert_equal(2, @google_ipo_news.coolness)
  #   
  #   # 2 cool 2 uncool for @dell_printer_gossip
  #   [@bob, @dave].each { |user| @dell_printer_gossip.rate(user, 1) }
  #   [@sally, @jack].each { |user| @dell_printer_gossip.rate(user, -1) }
  #   assert_equal(0, @dell_printer_gossip.coolness)
  #   
  #   highest = Post.find_highest_rated(:threshold => 0, :limit => 3)
  #   assert_equal(highest, [@apple_iphone_news, @google_ipo_news, @dell_printer_gossip])
  #   
  #   highest = Post.find_highest_rated(:threshold => 2, :limit => 3)
  #   assert_equal(highest, [@apple_iphone_news, @google_ipo_news])
  #   
  #   highest = Post.find_highest_rated(:threshold => 3, :limit => 3)
  #   assert_equal(highest, [@apple_iphone_news])    
  # end

  def test_undoing_rating
    @post.rate(@bob, 1)
    assert_equal(1, @post.cools)
    assert_equal(0, @post.uncools)

    # rating twice with same value should remove rating
    @post.rate(@bob, 1)
    assert_equal(0, @post.cools)
    assert_equal(0, @post.uncools)
  end
  
  def test_reversing_rating
    assert_equal(0, @post.cools)
    assert_equal(0, @post.uncools)

    @post.rate(@bob, 1)
    assert_equal(1, @post.cools)
    assert_equal(0, @post.uncools)

    @post.rate(@bob, -1)
    assert_equal(0, @post.cools)
    assert_equal(1, @post.uncools)
  end
  
end