class CreateCountries < ActiveRecord::Migration

  def self.up
    create_table :countries do |t|
      t.string :name, :limit => 100, :null => false
      t.string :code, :limit => 2, :null => false, :unique => true
      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
  
end
