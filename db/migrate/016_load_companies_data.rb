require 'active_record/fixtures' 

class LoadCompaniesData < ActiveRecord::Migration

  def self.up
    down 
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "companies") 
  end

  def self.down
    Company.delete_all 
  end

end
