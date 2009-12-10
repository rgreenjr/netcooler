require 'active_record/fixtures' 

class LoadUsersData < ActiveRecord::Migration

  def self.up
    down 
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "users") 
  end

  def self.down
    User.delete_all 
  end

end
