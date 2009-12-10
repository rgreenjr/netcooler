require "#{File.dirname(__FILE__)}/../test_helper"

class RoutesTest < ActionController::IntegrationTest  

  def test_root_routing
    assert_routing '', { :controller => 'site', :action => 'index' }
  end

end