require File.dirname(__FILE__) + '/../test_helper'
require 'tags_controller'

# Re-raise errors caught by the controller.
class TagsController; def rescue_action(e) raise e end; end

class TagsControllerTest < ActionController::TestCase

  fixtures :companies, :tags, :users

  def setup
    super
    @tag = tags(:innovative)
    @bob = users(:bob)
    @apple = companies(:apple)
  end

  def test_index
    get :index
    assert_response :success
    assert_valid_markup if should_validate_markup
  end

  def test_index_with_user
    get :index, :user_id => @bob.username
    assert_response :success
    assert_template 'tags/index'
    assert_equal(@bob.tags.size, assigns["tags"].size)
    assert_valid_markup if should_validate_markup
  end

  def test_index_with_company
    get :index, :company_id => @apple.id
    assert_response :success
    assert_template 'tags/index'
    assert_equal(@apple.tags.size, assigns["tags"].size)
    assert_valid_markup if should_validate_markup
  end

  def test_show
    get :show, :id => @tag.name
    assert_response :success
    assert_template 'tags/show'
    assert_kind_of Tag, assigns(:tag)
    assert_equal @tag.name, assigns(:tag).name
    assert_select 'h1', :text => /Tagged with innovative/
    assert_valid_markup if should_validate_markup
  end

  def test_show_unknown_tag
    get :show, :id => 'dsjfkalasdahsdjk'
    assert_response :success
    assert_template 'tags/show'
    assert_kind_of NilClass, assigns(:tag)
    assert_select 'h1', :text => /Tag not found/
    assert_valid_markup if should_validate_markup
  end

  # def test_show_tag_with_period
  #   get :show, :id => '.net'
  #   assert_response :success
  #   assert_template 'tags/index'
  #   assert_kind_of NilClass, assigns(:tag)
  #   assert_select 'h1', :text => /Tag not found/
  # end

end
