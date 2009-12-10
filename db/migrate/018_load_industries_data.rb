require 'active_record/fixtures' 

class LoadIndustriesData < ActiveRecord::Migration

  def self.up
    down 
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "industries") 
  end

  def self.down
    Industry.delete_all 
  end

end
