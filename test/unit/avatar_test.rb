require File.dirname(__FILE__) + '/../test_helper'

class AvatarTest < Test::Unit::TestCase
  
  fixtures :users
  
  def setup
    @bob = users(:bob)
  end
  
  def test_create
    count = Avatar.count
    avatar = Avatar.new(:uploaded_data => fixture_file_upload('avatars/small_image.jpg', 'image/jpeg'))
    assert avatar.valid?
    @bob.avatar = avatar
    assert @bob.save
    assert_equal(count + 4, Avatar.count)
  end

  def test_create_fails_without_attributes
    avatar = Avatar.new
    assert !avatar.valid?
    assert avatar.errors.invalid?(:base)
    assert_equal "No file was selected", avatar.errors[:base]
  end
  
  def test_create_fails_when_image_too_big
    avatar = Avatar.new(:user => @bob, :uploaded_data => fixture_file_upload('avatars/big_image.jpg', 'image/jpeg'))
    assert !avatar.valid?
    assert avatar.errors.invalid?(:base)
    assert_equal "Image must be 1MB or less", avatar.errors[:base]
  end

  def test_create_fails_with_non_image
    avatar = Avatar.new(:user => @bob, :uploaded_data => fixture_file_upload('avatars/textfile.txt', 'text/plain'))
    assert !avatar.valid?
    assert avatar.errors.invalid?(:base)
    assert_equal "File must be an image", avatar.errors[:base]
  end
  
  def test_public_filename
    avatar = Avatar.new(:uploaded_data => fixture_file_upload('avatars/small_image.jpg', 'image/jpeg'))
    @bob.avatar = avatar
    assert @bob.save
    @bob.reload
    assert_match(/avatars\/[0-9]*-small_image_medium.jpg/i, @bob.avatar.public_filename)
    assert_match(/avatars\/[0-9]*-small_image_small.jpg/i, @bob.avatar.public_filename(:small))
    assert_match(/avatars\/[0-9]*-small_image_large.jpg/i, @bob.avatar.public_filename(:large))
  end

end
