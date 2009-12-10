require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  
  fixtures  :users, :companies, :posts
  
  def setup
    @bob = users(:bob)
    @google = companies(:google)
    @news = posts(:apple_iphone_news)
    @gossip = posts(:apple_iphone_gossip)
    @question = posts(:apple_question)
  end
  
  def test_invalid_without_attributes
    comment = Comment.new
    assert !comment.valid?
    assert comment.errors.invalid?(:body)
    assert comment.errors.invalid?(:user)
    # assert comment.errors.invalid?(:commentable)
  end
  
  def test_add_comment_to_news
    comment = Comment.new(:user => @bob, :body => 'This is a test news comment')
    assert @news.comments << comment
    assert_equal(@news, comment.commentable)
  end
  
  def test_add_comment_to_gossip
    comment = Comment.new(:user => @bob, :body => 'This is a test gossip comment')
    assert @gossip.comments << comment
    assert_equal(@gossip, comment.commentable)
  end
  
  def test_add_comment_to_question
    comment = Comment.new(:user => @bob, :body => 'This is a test question comment')
    assert @question.comments << comment
    assert_equal(@question, comment.commentable)
  end
  
  def test_tag_stripping
    comment = Comment.new(:user => @bob, :body => %{<a href="javascript: sucker();">Click here for $100</a>})
    assert @question.comments << comment
    assert_equal %{<p>Click here for $100</p>}, comment.body_html
  end
  
  def test_xss_attacks
    assert @question.comments << Comment.new(:user => @bob, :body => %{>"'><script>alert(‘XSS')</script>})
    assert_equal %{<p>>"'>alert(‘XSS')</p>}, @question.comments.last.body_html

    assert @question.comments << Comment.new(:user => @bob, :body => %{>%22%27><img%20src%3d%22javascript:alert(%27XSS%27)%22>})
    assert_equal %{<p>>%22%27></p>}, @question.comments.last.body_html

    assert @question.comments << Comment.new(:user => @bob, :body => %{>"'><img%20src%3D%26%23x6a;%26%23x61;%26%23x76;%26%23x61;%26%23x73;%26%23x63;%26%23x72;%26%23x69;%26%23x70;%26%23x74;%26%23x3a;alert(%26quot;XSS%26quot;)>})
    assert_equal %{<p>>"'></p>}, @question.comments.last.body_html

    assert @question.comments << Comment.new(:user => @bob, :body => %{AK%22%20style%3D%22background:url(javascript:alert(%27XSS%27))%22%20OS%22})
    assert_equal %{<p>AK%22%20style%3D%22background:url(javascript:alert(%27XSS%27))%22%20OS%22</p>}, @question.comments.last.body_html

    assert @question.comments << Comment.new(:user => @bob, :body => %{%22%2Balert(%27XSS%27)%2B%22})
    assert_equal %{<p>%22%2Balert(%27XSS%27)%2B%22</p>}, @question.comments.last.body_html

    comment = Comment.new(:user => @bob, :body => %{<table background="javascript:alert(([code])"></table>})
    assert !comment.valid?
    assert_equal '', comment.body

    comment = Comment.new(:user => @bob, :body => %{<object type=text/html data="javascript:alert(([code]);"></object>})
    assert !comment.valid?
    assert_equal '', comment.body

    comment = Comment.new(:user => @bob, :body => %{<body onload="javascript:alert(([code])"></body>})
    assert !comment.valid?
    assert_equal '', comment.body
  end
  
end
