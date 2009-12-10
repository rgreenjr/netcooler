require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'
require 'feed_validator/assertions'

# Re-raise errors caught by the controller.
class SiteController; def rescue_action(e) raise e end; end

class SiteControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success
    assert_template 'site/index'
    # assert_valid_markup if should_validate_markup
  end
  
  def test_index_with_format_atom
    get :index, :format => 'atom'
    assert_response :success
    assert_template 'site/index'
    assert_select "title", "Netcooler"
    # puts @response.body
    assert_valid_feed
  end

end
