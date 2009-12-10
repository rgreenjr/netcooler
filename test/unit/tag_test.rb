require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase

  fixtures :tags, :users, :posts, :companies

  def setup
    @dave = users(:dave)
    @apple_news = posts(:apple_iphone_news)
    @google_news = posts(:google_ipo_news)
    @innovative = tags(:innovative)
    @apple = companies(:apple)
    @google = companies(:google)
  end

  def test_associations
    assert_working_associations
  end

  def test_invalid_without_name
    tag = Tag.new
    assert !tag.valid?
    assert tag.errors.invalid?(:name)
  end
  
  def test_create
    assert Tag.create(:name => 'secrective')
  end
  
  def test_name_uniqueness
    tag = Tag.new(:name => @innovative.name)
    assert !tag.valid?
    assert_equal "has already been taken", tag.errors[:name]
  end
  
  def test_case_insensitive
    tag = Tag.new(:name => @innovative.name.upcase)
    assert !tag.valid?
    assert_equal "has already been taken", tag.errors[:name]
  end
  
  def test_names_are_downcased
    tag = Tag.new(:name => 'MixED-Case')
    assert tag.save
    assert_equal('mixed-case', tag.name)
  end
  
  def test_find_recently_used
    @google_news.tag_string = 'aa bb innovative dd creative ee ff'
    assert @google_news.save
    @google_news.reload
    assert_equal(7, @google_news.tags.size)
    
    @google_news.tag_string = 'aa hh innovative'
    assert @google_news.save
    @google_news.reload
    assert_equal(3, @google_news.tags.size)
    
    recent = Tag.find_recently_used
    assert recent.collect {|t| t.name}.join(' ') == 'aa hh innovative'
  end
  
  def test_all_with_count
    @apple_news.tag_string = 'innovative'
    @apple_news.save
    @apple_news.reload
    assert_equal(1, @apple_news.tags.size)

    @google_news.tag_string = 'aa bb cc dd innovative'
    assert @google_news.save
    @google_news.reload
    assert_equal(5, @google_news.tags.size)

    all_tags = Tag.all_with_count
    all_tags.each { |t| t.count = 1 unless t.name == 'innovative' }
  end
  
  def test_find_popular
    @apple_news.tag_string = 'aa innovative creative'
    @apple_news.save
    @apple_news.reload
    assert_equal(3, @apple_news.tags.size)

    @google_news.tag_string = 'bb creative cc dd innovative'
    assert @google_news.save
    @google_news.reload
    assert_equal(5, @google_news.tags.size)

    popular = Tag.find_popular(:limit => 2)
    assert_equal(2, popular.size)
    assert popular.collect {|t| t.name}.join(' ') == 'creative innovative'
  end
  
  def test_to_param
    assert_equal('innovative', @innovative.to_param)
  end
  
end
