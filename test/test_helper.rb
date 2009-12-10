ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

# need to include these ActionView::Helpers prevent errors in Comment unit tests
include ActionView::Helpers::TextHelper
include ActionView::Helpers::TagHelper

class Test::Unit::TestCase
    
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...

  def login_as(user)
    @request.session[:user_id] = user.id
  end
  
  def logout
    @request.session[:user_id] = nil
  end

  def assert_invalid_value(model_class, attribute, value)
    if value.kind_of? Array
      value.each { |v| assert_invalid_value model_class, attribute, v }
    else
      record = model_class.new(attribute => value)
      assert !record.valid?, "#{model_class} expected to be invalid when #{attribute} is #{value}"
      assert record.errors.invalid?(attribute), "#{attribute} expected to be invalid when set to #{value}"
    end
  end 

  def assert_valid_value(model_class, attribute, value)
    if value.kind_of? Array
      value.each { |v| assert_valid_value model_class, attribute, v }
    else
      record = model_class.new(attribute => value)
      #assert !record.valid?, "#{model_class} expected to be invalid when #{attribute} is #{value}"
      assert !record.errors.invalid?(attribute), "#{attribute} expected to be valid when set to #{value}"
    end
  end
  
  def should_validate_markup
    false
  end

  def assert_working_associations(m=nil)
    m ||= self.class.to_s.sub(/Test$/, '').constantize
    @m = m.new
    m.reflect_on_all_associations.each do |assoc|
      assert_nothing_raised("#{assoc.name} caused an error") do
        @m.send(assoc.name, true)
      end
    end
    true
  end
  
end
