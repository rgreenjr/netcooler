class CreateTaggings < ActiveRecord::Migration

  def self.up
    create_table :taggings do |t| 
      t.column :tag_id, :integer, :null => false
      t.column :taggable_id, :integer, :null => false
      t.column :taggable_type, :string, :null => false
      t.column :user_id, :integer, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :taggings, :user_id
    add_index :taggings, :tag_id
    add_index :taggings, :taggable_id
    add_index :taggings, :taggable_type
    add_index :taggings, [:taggable_id, :taggable_type]

    create_table :tags do |t| 
      t.column :name, :string, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end 

    add_index :tags, :name
  end

  def self.down
    drop_table :taggings 
    drop_table :tags
  end
  
end
