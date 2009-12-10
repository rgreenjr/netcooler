class MakeStateIdNullableOnOffices < ActiveRecord::Migration

  def self.up
    change_column :offices, :state_id, :integer, :null => true
  end

  def self.down
    change_column :offices, :state_id, :integer, :null => false
  end
end

