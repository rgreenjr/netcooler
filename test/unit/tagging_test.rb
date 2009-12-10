require File.dirname(__FILE__) + '/../test_helper'

class TaggingTest < Test::Unit::TestCase

  def setup
    @acme = Company.create!(:name => 'Acme, Inc', :url => 'http://www.acme.com/', :industry => Industry.find(:first))
    @user = User.create!(:first_name => 'John', :last_name => 'Doe', :username => 'jdoe',  :email => 'jdoe@example.com',   :password => 'pass', :password_confirmation => 'pass')
    @post = Post.create!(:user => @user, :company => @acme, :category => 'News', :title => 'title', :url => "http://www.example.com/", :body => 'body')
  end

  def test_invalid_without_attributes
    tagging = Tagging.new
    assert !tagging.valid?
    assert tagging.errors.invalid?(:user)
    assert tagging.errors.invalid?(:tag)
    assert tagging.errors.invalid?(:taggable)
  end
  
  def test_multiple_tags
    tags_list = "fooz barz"
    count = @post.user.tags.size
    @post.tag_string = tags_list
    assert @post.save
    @post.reload
    assert_equal(2, @post.tags.size)
    assert_equal(count + 2, @post.user.tags.size)
  end
  
  def test_tagging_news
    tag_name = "mp3"
    assert Post.find_tagged_with(tag_name).empty?
    assert @post.tag_string = tag_name
    assert @post.save
    @post.reload

    assert_equal(1, Post.find_tagged_with(tag_name).size)
    assert_equal(1, @post.tags.size)
    assert_equal(tag_name, @post.tags.first.name)
    assert_equal(1, @post.taggings.size)
    assert_equal(tag_name, @post.taggings.first.tag.name)
      
    # make sure re-tagging with same tag by same user doesn't create duplicates
    @post.tag_string = tag_name
    assert @post.save
    @post.reload

    assert_equal(1, Post.find_tagged_with(tag_name).size)
    assert_equal(1, @post.tags.size)
    assert_equal(tag_name, @post.tags.first.name)
    assert_equal(1, @post.taggings.size)
    assert_equal(tag_name, @post.taggings.first.tag.name)
  end
  
  def test_delete
    tag_name = "mp3"

    assert Post.find_tagged_with(tag_name).empty?
    @post.tag_string = tag_name
    assert @post.save
    assert_equal(1, Post.find_tagged_with(tag_name).size)
    assert_equal(1, Tagging.count)
    
    tag = Tag.find_by_name(tag_name)

    Tagging.delete_from(@post, [tag])
    assert_equal(0, Tagging.count)
    assert_equal(0, Post.find_tagged_with(tag_name).size)
  end

end
