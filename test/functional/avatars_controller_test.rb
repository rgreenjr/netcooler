require File.dirname(__FILE__) + '/../test_helper'
require 'avatars_controller'

# Re-raise errors caught by the controller.
class AvatarsController; def rescue_action(e) raise e end; end

class AvatarsControllerTest < ActionController::TestCase

  fixtures  :users

  def setup
    super
    @bob = users(:bob)
  end
  
  def test_new
    login_as @bob
    get :new, :user_id => @bob.username
    assert_response :success
    assert_kind_of Avatar, assigns(:avatar) 
  end

  def test_new_fails_without_login
    count = Avatar.count
    post :new, :user_id => @bob.username
    assert_equal(count, Avatar.count)
    assert_redirected_to new_session_url
  end

  def test_create
    login_as @bob
    assert_equal(nil, @bob.avatar)
    count = Avatar.count
    post :create, { :user_id => @bob.username, :filename => fixture_file_upload('avatars/small_image.jpg', 'image/jpeg') }
    assert_equal(count + 4, Avatar.count)
    assert_redirected_to user_path(@bob)
    @bob.reload
    assert_equal('small_image.jpg', @bob.avatar.filename)
    # puts @response.body
  end

  def test_create_fails_without_login
    count = Avatar.count
    post :create, { :user_id => @bob.username, :filename => fixture_file_upload('avatars/small_image.jpg', 'image/jpeg') }
    assert_equal(count, Avatar.count)
    assert_redirected_to new_session_url
  end

  def test_create_fails_without_selection
    login_as @bob
    count = Avatar.count
    post :create, :user_id => @bob.username
    assert_equal(count, Avatar.count)
    assert_template 'new'
    assert_select 'li', :text => /No file was selected/
  end

  def test_create_fails_with_non_image
    login_as @bob
    count = Avatar.count
    post :create, { :user_id => @bob.username, :filename => fixture_file_upload('avatars/textfile.txt', 'text/plain') }
    assert_equal(count, Avatar.count)
    assert_template 'new'
    assert_select 'li', :text => /File must be an image/
  end

  def test_create_fails_when_image_too_big
    login_as @bob
    count = Avatar.count
    post :create, { :user_id => @bob.username, :filename => fixture_file_upload('avatars/big_image.jpg', 'image/jpeg') }
    assert_equal(count, Avatar.count)
    assert_template 'new'
    assert_select 'li', :text => /Image must be 1MB or less/
  end
  
  def test_edit
    add_avatar_for(@bob)
    get :edit, :user_id => @bob.username, :id => @bob.avatar
    assert_response :success
    assert_template 'edit'
    assert_kind_of Avatar, assigns(:avatar) 
  end

  def test_edit_fails_without_login
    add_avatar_for(@bob)
    logout
    count = Avatar.count
    get :edit, :user_id => @bob.username, :id => @bob.avatar
    assert_equal(count, Avatar.count)
    assert_redirected_to new_session_url
  end

  def test_update
    add_avatar_for(@bob)
    count = Avatar.count
    put :update, :user_id => @bob.username, :id => @bob.avatar, :_method => :put, :filename => fixture_file_upload('avatars/medium_image.jpg', 'image/jpeg')    
    assert_equal(count, Avatar.count)
    assert_redirected_to user_path(@bob)
    @bob.reload
    assert_equal('medium_image.jpg', @bob.avatar.filename)
    # puts @response.body
  end

  def test_update_fails_without_login
    add_avatar_for(@bob)
    logout
    count = Avatar.count
    put :update, :user_id => @bob.username, :id => @bob.avatar, :_method => :put, :filename => fixture_file_upload('avatars/medium_image.jpg', 'image/jpeg')    
    assert_equal(count, Avatar.count)
    assert_redirected_to new_session_url
  end

  def test_update_fails_without_selection
    add_avatar_for(@bob)
    login_as @bob
    count = Avatar.count
    put :update, :user_id => @bob.username, :id => @bob.avatar, :_method => :put, :filename => ''   
    assert_equal(count, Avatar.count)
    assert_template 'edit'
    assert_select 'li', :text => /No file was selected/
  end

  def test_update_fails_with_non_image
    add_avatar_for(@bob)
    login_as @bob
    count = Avatar.count
    put :update, :user_id => @bob.username, :id => @bob.avatar, :_method => :put, :filename => fixture_file_upload('avatars/textfile.txt', 'text/plain')
    assert_equal(count, Avatar.count)
    assert_template 'edit'
    assert_select 'li', :text => /File must be an image/
  end

  def test_update_fails_when_image_too_big
    add_avatar_for(@bob)
    login_as @bob
    count = Avatar.count
    put :update, :user_id => @bob.username, :id => @bob.avatar, :_method => :put, :filename => fixture_file_upload('avatars/big_image.jpg', 'image/jpeg')    
    assert_equal(count, Avatar.count)
    assert_template 'edit'
    assert_select 'li', :text => /Image must be 1MB or less/
  end
  
  def add_avatar_for(user)
    login_as user
    assert_equal(nil, user.avatar)
    count = Avatar.count
    post :create, { :user_id => user.username, :filename => fixture_file_upload('avatars/small_image.jpg', 'image/jpeg') }
    assert_equal(count + 4, Avatar.count)
    assert_redirected_to user_path(user)
    user.reload
    assert_equal('small_image.jpg', user.avatar.filename)
  end

end
