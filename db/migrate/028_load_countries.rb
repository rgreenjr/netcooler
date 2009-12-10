require 'yaml'

class LoadCountries < ActiveRecord::Migration
    
  def self.up
    Country.transaction do
      YAML::load_file(File.join(File.dirname(__FILE__), "data", "countries.yml")).sort.each do |entry|
        begin
          country = Country.new
          country.name = entry[1]["name"]
          country.code = entry[1]["code"]
          country.save!
        rescue Exception => e
          raise "Aborting migration: country '#{country.name}' #{country.errors.full_messages} #{e.message}"
        end
      end
    end
  end

  def self.down
    Country.delete_all
  end

end
