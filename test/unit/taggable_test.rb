require File.dirname(__FILE__) + '/../test_helper'

class TaggableTest < Test::Unit::TestCase

  fixtures :tags, :users, :posts, :companies

  def setup
    @jack = users(:jack)
    @post = posts(:apple_iphone_news)
    @innovative = tags(:innovative)
  end
  
  def test_tag_string
    @post.tag_string = 'hello goodbye'
    assert @post.save
    @post.reload
    assert_equal('goodbye hello', @post.tag_string)
  end

  def test_find_tagged_with
    @apple_iphone_news = posts(:apple_iphone_news)
    @google_ipo_news = posts(:google_ipo_news)
    @dell_printer_gossip = posts(:dell_printer_gossip)

    @apple_iphone_news.tag_string = 'aa bb cc'
    assert @apple_iphone_news.save
    @apple_iphone_news.reload
    
    @google_ipo_news.tag_string = 'aa bb'
    assert @google_ipo_news.save
    @google_ipo_news.reload
    
    @dell_printer_gossip.tag_string = 'aa'
    assert @dell_printer_gossip.save
    @dell_printer_gossip.reload
    
    tagged_with_aa = Post.find_tagged_with('aa')
    [@apple_iphone_news, @google_ipo_news, @dell_printer_gossip].each { |post| assert tagged_with_aa.include?(post) }
    
    tagged_with_bb = Post.find_tagged_with('bb')
    [@apple_iphone_news, @google_ipo_news].each { |post| assert tagged_with_bb.include?(post) }
    
    tagged_with_cc = Post.find_tagged_with('cc')
    [@apple_iphone_news].each { |post| assert tagged_with_cc.include?(post) }
  end

end