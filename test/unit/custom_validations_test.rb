require File.dirname(__FILE__) + '/../test_helper'

class CustomValidationsTest < Test::Unit::TestCase

  fixtures :users, :companies, :offices
  
  def setup
    @bob = users(:bob)
    @apple = companies(:apple)
    @apple_office = offices(:apple_office)
  end
  
  def test_valid_emails
    ['simple@example.com', 'multidomain@example.co.uk', 'with-a-dash@example.com'].each do |value|
      @bob.email = value
      assert @bob.valid?
    end
  end
  
  def test_invalid_emails
    ['with spaces @example.com', 'extra_at_symbal@@example.com', 'missing_at_symbol.example.comm'].each do |value|
      @bob.email = value
      assert !@bob.valid?
      @bob.errors.invalid?(:email)
      assert_equal "is invalid", @bob.errors[:email]
    end
  end
  
  def test_valid_usernames
    ['johnboy', 'aa123', 'f451', 'imreallylongimreallylong'].each do |value|
      @bob.username = value
      assert @bob.valid?
    end
  end  
  
  def test_invalid_usernames
    ["appostrphe'er", '007', 'with_underscore', 'with-dash', "<script>alert('cross scripting attack')</script>"].each do |value|
      @bob.username = value
      assert !@bob.valid?
      @bob.errors.invalid?(:username)
      assert_equal "must begin with a letter and may only contain letters and numbers", @bob.errors[:username]
    end
  end  
  
  def test_valid_urls
    ['http://www.foo.com/', 'http://example.com/foo/bar#section?a=one&b=two', 'http://www.sussex.ac.uk/'].each do |value|
      @apple.url = value
      assert @apple.valid?
    end
  end
  
  def test_invalid_urls
    ['htt://www.foo.com/', 'http:/example.com/', 'http:example.com/', 'http:///www.example.com'].each do |value|
      @apple.url = value
      assert !@apple.valid?
      @apple.errors.invalid?(:url)
      assert_equal "is invalid", @apple.errors[:url]
    end
  end
  
  def test_valid_tags
    ['lowercase',
      'UPPERCASE',
      'MixedCase',
      'with123numbers',
      'with-dash',
      'with.period',
      'with_underscore',
      'with&amperstand'].each do |value|
      tag = Tag.new(:name => value)
      assert tag.valid?
    end
  end
  
  def test_invalid_tags
    ['with space',
      'with lots of space chars',
      'with+symbol',
      'with@symbol',
      'with*asteric'].each do |value|
        tag = Tag.new(:name => value)
        assert !tag.valid?
        assert_equal "may only contain letters, numbers, ., &, -, and _ symbols", tag.errors[:name]
    end
  end
  
  def test_valid_zips
    %w(78701 78701-1234 55555-5555).each do |value|
      @apple_office.zip = value
      assert @apple_office.valid?
    end
  end
  
  def test_invalid_zips
    %w(123456 1 x 78701-12345 55555- aaaaa bbbbb-cccc).each do |value|
      @apple_office.zip = value
      assert !@apple_office.valid?
      assert_equal "is invalid", @apple_office.errors[:zip]
    end
  end
  
end
