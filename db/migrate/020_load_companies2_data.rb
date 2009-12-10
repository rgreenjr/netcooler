require 'yaml'

class LoadCompanies2Data < ActiveRecord::Migration

  # law firms
  
  def self.up
    Company.transaction do
      YAML::load_file(File.join(File.dirname(__FILE__), "data", "companies2.yml")).each_value do |entry|
        begin
          company               = Company.new
          company.name          = entry['name']
          company.url           = entry['url']
          company.description   = entry['description']
          company.industry      = Industry.find_by_name(entry['industry'])
          company.ticker_symbol = entry['ticker_symbol']
          company.created_at    = entry['created_at'] if entry['created_at']
          company.updated_at    = entry['updated_at'] if entry['updated_at']
          
          office                = Office.new
          office.street1        = entry['street1']
          office.street2        = entry['street2']
          office.city           = entry['city']
          office.state          = State.find_by_abbreviation(entry['state'])
          office.zip            = entry['zip']
          
          company.offices << office

          company.save!
        rescue Exception => e
          raise "Aborting migration: company '#{company.name}' #{company.errors.full_messages} #{e.message}"
        end
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
