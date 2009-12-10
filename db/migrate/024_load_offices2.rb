require 'yaml'

class LoadOffices2 < ActiveRecord::Migration

  # law firms
  
  def self.up
    Company.transaction do
      YAML::load_file(File.join(File.dirname(__FILE__), "data", "offices2.yml")).each_value do |entry|
        begin
          # puts entry.inspect
          company  = Company.find_by_name(entry['name'])
          industry = Industry.find_by_name(entry['industry'])
          state    = State.find_by_name(entry['state'])
          raise "Aborting migration: Company '#{entry['name']}' doesn't exist" if company.nil?
          raise "Aborting migration: Company '#{entry['name']}' ID #{company.id} doesn't match #{entry['id']}" if company.id != entry['id']
          raise "Aborting migration: Industry '#{entry['industry']}' doesn't exist" if industry.nil?
          raise "Aborting migration: State '#{entry['state']}' doesn't exist" if state.nil?
          
          company.industry = industry
          office = company.offices.first
          if office
            office.state = state
            office.city = entry['city']
            # puts "company #{company.name} should update office"
          else
            company.offices << Office.new(:city => entry['city'], :state => state)
          end
          company.save!
        rescue Exception => e
          puts entry.inspect
          raise "Aborting migration: company '#{entry['name']}' #{e.message}"
        end
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
