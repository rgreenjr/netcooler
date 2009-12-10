class CreateIndustries < ActiveRecord::Migration
  
  def self.up
    create_table :industries do |t|
      t.column :name, :string, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :industries, :name
  end

  def self.down
    drop_table :industries
  end

end
