class AddCountryIdToOffices < ActiveRecord::Migration

  def self.up
    add_column :offices, :country_id, :integer, :null => false
  end

  def self.down
    remove_column :offices, :country_id
  end
end
