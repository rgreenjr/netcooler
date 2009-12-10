require File.dirname(__FILE__) + '/../test_helper'

class PostTest < Test::Unit::TestCase

  def setup
    @acme = Company.create!(:name => 'Acme, Inc', :url => 'http://www.acme.com/', :industry => Industry.find(:first))
    @bob = User.create!(:first_name => 'Bob', :last_name => 'Smith', :username => 'bsmith',  :email => 'bsmith@example.com',   :password => 'pass', :password_confirmation => 'pass')
    @dave = User.create!(:first_name => 'Dave', :last_name => 'Taylor', :username => 'dtaylor',  :email => 'dtaylor@example.com',   :password => 'pass', :password_confirmation => 'pass')
    @post = Post.create!(:user => @bob, :company => @acme, :category => 'News', :title => 'title', :url => "http://www.example.com/", :body => 'body')
  end

  def test_associations
    assert_working_associations
  end

  def test_valid_with_attributes
    post = Post.new(:user => @bob, :title => 'Test News Posting', :body => 'This is a test news posting.', :url => 'http://www.example.com/', :category => 'News')
    assert @acme.posts << post
  end
  
  def test_invalid_without_attributes
    post = Post.new
    assert !post.valid?
    assert post.errors.invalid?(:title)
    assert post.errors.invalid?(:body)
    assert post.errors.invalid?(:user)
    assert post.errors.invalid?(:company)
    assert post.errors.invalid?(:category)
  end
  
  def test_news_posts_require_url
    post = Post.new(:user => @bob, :title => 'Test News Posting', :body => 'This is a test news posting.', :company_id => @acme.id, :category => 'News')
    assert !post.valid?
    assert post.errors.invalid?(:url)
    assert_equal "can't be blank", post.errors[:url]
  end
  
  def test_gossip_posts_do_not_require_url
    post = Post.new(:user => @bob, :title => 'Test News Posting', :body => 'This is a test news posting.', :company_id => @acme.id, :category => 'Gossip')
    assert post.valid?
  end
  
  def test_question_posts_do_not_require_url
    post = Post.new(:user => @bob, :title => 'Test News Posting', :body => 'This is a test news posting.', :company_id => @acme.id, :category => 'Question')
    assert post.valid?
  end
  
  def test_adding_comment
    comment = Comment.new(:user => @bob, :body => 'This is a test comment')
    assert @post.comments << comment
  end
  
  def test_hitting
    hits = @post.views
    @post.hit!
    @post.hit!
    @post.reload
    assert_equal hits + 2, @post.views
  end
  
  def test_changing_status
    assert !@post.blocked?
    @post.status = 'Blocked'
    assert @post.valid?
    assert @post.save
    assert @post.blocked?
    @post.status = 'Approved'
    assert @post.valid?
    assert @post.save
    assert !@post.blocked?
    @post.status = 'adsfhadhfjkladf'
    assert !@post.valid?
    assert @post.errors.invalid?(:status)
  end
  
  def test_to_param
    post = Post.create(:user => @bob, :title => 'Simple Title', :body => 'This is a test news posting.', :category => 'News')
    assert_equal("#{post.id}-Simple-Title", post.to_param)
    
    post = Post.create(:user => @bob, :title => 'Title_with*lots+of%different##~characters     () in it', :body => 'This is a test news posting.', :category => 'News')
    assert_equal("#{post.id}-Title-with-lots-of-different-characters-in-it", post.to_param)

    post = Post.create(:user => @bob, :title => '123Starts with numbers', :body => 'This is a test news posting.', :category => 'News')
    assert_equal("#{post.id}-123Starts-with-numbers", post.to_param)
  end

  def test_atom_id
    assert_equal("tag:netcooler.com,#{@post.created_at.strftime("%Y-%m-%d")}:/companies/#{@post.company.id}/posts/#{@post.id}", @post.atom_id)
  end
  
  def test_domain
    @post.url = 'http://www.nytimes.com/2007/07/20/washington/20vote.html?_r=1&hp=&adxnnl=1&oref=slogin&adxnnlx=1184900451-32uFx9G2x1X7nPumHi3+Og'
    assert_equal('nytimes.com', @post.domain)
    @post.url = 'http://sportsillustrated.cnn.com/2007/football/nfl/07/19/bc.fbn.vick.nike.ap/index.html?cnn=yes'
    assert_equal('sportsillustrated.cnn.com', @post.domain)
    @post.url = 'http://ktvu.com/news/13714462/detail.html'
    assert_equal('ktvu.com', @post.domain)
  end
  
end