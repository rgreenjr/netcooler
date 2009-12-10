require 'active_record/fixtures' 

class LoadStatesData < ActiveRecord::Migration

  def self.up
    down 
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "states") 
  end

  def self.down
    State.delete_all 
  end

end
