require 'active_record/fixtures' 

class LoadOfficesData < ActiveRecord::Migration

  def self.up
    down 
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "offices") 
  end

  def self.down
    Office.delete_all 
  end

end
