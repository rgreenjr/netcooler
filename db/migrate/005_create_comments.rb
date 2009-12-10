class CreateComments < ActiveRecord::Migration

  def self.up
    create_table :comments do |t|
      t.column :user_id, :integer, :null => false      
      t.column :commentable_id, :integer, :null => false
      t.column :commentable_type, :string, :null => false
      t.column :body, :text
      t.column :body_html, :text
      t.column :status, :string, :default => 'Approved', :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end
    
    add_index :comments, :user_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
    add_index :comments, [:commentable_id, :commentable_type]
  end

  def self.down
    drop_table :comments
  end

end
