class CreatePosts < ActiveRecord::Migration

  def self.up
    create_table :posts do |t|
      t.column :user_id, :integer, :null => false
      t.column :company_id, :integer, :null => false
      t.column :category, :string, :null => false
      t.column :title, :string
      t.column :body, :text
      t.column :body_html, :text
      t.column :url, :string
      t.column :hits, :integer, :default => 0, :null => false
      t.column :status, :string, :default => 'Approved', :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :posts, :user_id
    add_index :posts, :company_id
    add_index :posts, [:company_id, :status, :created_at]
  end
    
  def self.down
    drop_table :posts
  end

end
