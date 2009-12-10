require 'yaml'

class LoadCompanies3Data < ActiveRecord::Migration

  # missing companies necessary to reload previous production posts

  def self.up
    Company.transaction do
      YAML::load_file(File.join(File.dirname(__FILE__), "data", "companies3.yml")).each_value do |entry|
        begin
          company               = Company.new
          company.name          = entry['name']
          company.url           = entry['url']
          company.description   = entry['description']
          company.industry      = Industry.find_by_name(entry['industry'])
          company.ticker_symbol = entry['ticker_symbol']
          company.created_at    = entry['created_at'] if entry['created_at']
          company.updated_at    = entry['updated_at'] if entry['updated_at']
          
          company.save!
        rescue Exception => e
          raise "Aborting migration: company '#{company.name}' #{company.errors.full_messages} #{e.message}"
        end
      end
    end
  end

  def self.down
    # raise ActiveRecord::IrreversibleMigration
  end

end
