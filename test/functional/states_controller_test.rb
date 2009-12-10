require File.dirname(__FILE__) + '/../test_helper'

class StatesControllerTest < ActionController::TestCase
  
  include Arts

  fixtures  :countries, :states

  def test_index_states_for_usa
    usa = countries(:usa)
    xhr :get, :index, :country_id => usa.id
    assert_response :success
    assert_template 'states/index'
    assert /Alabama/.match(@response.body)
    assert /Texas/.match(@response.body)
    assert_rjs :replace_html, 'office_state_id'
    assert_rjs :show, 'state_field'
    assert_rjs :show, 'zip_field'
  end
  
  def test_index_states_for_uk
    uk = countries(:uk)
    xhr :get, :index, :country_id => uk.id
    assert_response :success
    assert_template 'states/index'
    assert_rjs :hide, 'state_field'
    assert_rjs :hide, 'zip_field'
  end
  
end
