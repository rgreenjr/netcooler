class AddCountryIdToStates < ActiveRecord::Migration

  def self.up
    add_column :states, :country_id, :integer, :null => false
  end

  def self.down
    remove_column :states, :country_id
  end
end
