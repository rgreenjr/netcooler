class CreateStates < ActiveRecord::Migration

  def self.up
    create_table :states do |t|
      t.column :name, :string, :null => false
      t.column :abbreviation, :string, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :states, :name
    add_index :states, :abbreviation
  end

  def self.down
    drop_table :states
  end
end
