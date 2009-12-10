class CreateOffices < ActiveRecord::Migration

  def self.up
    create_table :offices do |t|
      t.column :company_id, :integer, :null => false
      t.column :street1, :string
      t.column :street2, :string
      t.column :city, :string, :null => false
      t.column :state_id, :integer, :null => false
      t.column :zip, :string
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :offices, :company_id
    add_index :offices, :state_id
  end

  def self.down
    drop_table :offices
  end

end
