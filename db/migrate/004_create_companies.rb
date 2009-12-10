class CreateCompanies < ActiveRecord::Migration

  def self.up
    create_table :companies do |t|
      t.column :name, :string, :null => false
      t.column :description, :text
      t.column :industry_id, :integer, :null => false
      t.column :url, :string, :null => false
      t.column :domain, :string, :null => false
      t.column :ticker_symbol, :string
      t.column :post_count, :integer, :default => 0, :null => false
      t.column :status, :string, :default => 'Approved', :null => false
      t.column :created_at, :datetime, :null => false      
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :companies, :name
    add_index :companies, :industry_id
    add_index :companies, :status
    add_index :companies, :domain
  end

  def self.down
    drop_table :companies
  end

end
