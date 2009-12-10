require 'yaml'

class LoadStates2Data < ActiveRecord::Migration
    
  def self.up
    State.transaction do
      load_data.each do |entry|
        begin
          state = State.new
          state.name = entry[1]["name"]
          state.abbreviation = entry[1]["abbreviation"]
          state.country = Country.find_by_name(entry[1]["country_name"])
          state.save!
        rescue Exception => e
          raise "Aborting migration: state '#{state.name}' #{state.errors.full_messages} #{e.message}"
        end
      end
    end
  end

  def self.down
    State.transaction do
      load_data.each do |entry|
        begin
          state = State.find_by_name(entry[1]["name"])
          state.destroy if state
        rescue Exception => e
          raise "Aborting migration: state '#{state.name}' #{state.errors.full_messages} #{e.message}"
        end
      end
    end
  end
  
  def self.load_data
    YAML::load_file(File.join(File.dirname(__FILE__), "data", "states2.yml")).sort
  end

end
