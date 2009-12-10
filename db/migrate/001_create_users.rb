class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.column :username, :string, :limit => 100, :null => false
      t.column :email, :string, :limit => 100, :null => false
      t.column :email_optin, :boolean, :default => 0, :null => false
      t.column :first_name, :string, :limit => 100, :null => false
      t.column :last_name, :string, :limit => 100, :null => false
      t.column :password_hash, :string, :limit => 40, :null => false
      t.column :admin, :boolean, :default => false, :null => false
      t.column :status, :string, :default => 'Registered', :null => false
      t.column :last_login_at, :datetime
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end
    
    add_index :users, :username
    add_index :users, :password_hash
    add_index :users, :email
    add_index :users, [:id, :username]
    add_index :users, [:id, :email]
    add_index :users, [:username, :password_hash]
  end

  def self.down
    drop_table :users
  end

end
