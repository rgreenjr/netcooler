class CreateRatings < ActiveRecord::Migration

  def self.up
    create_table :ratings do |t|
      t.column :user_id, :integer, :null => false      
      t.column :value, :integer, :null => false
      t.column :rateable_id, :integer, :null => false
      t.column :rateable_type, :string, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :updated_at, :datetime
      t.column :deleted_at, :datetime
    end

    add_index :ratings, :user_id
    add_index :ratings, :rateable_id
    add_index :ratings, :rateable_type
    add_index :ratings, [:rateable_id, :rateable_type]
    add_index :ratings, [:user_id, :rateable_type]
    add_index :ratings, [:user_id, :rateable_id, :rateable_type]
  end
    
  def self.down
    drop_table :ratings
  end

end
