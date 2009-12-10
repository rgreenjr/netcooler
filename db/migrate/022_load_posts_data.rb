require 'yaml'

class LoadPostsData < ActiveRecord::Migration

  def self.up
    Post.transaction do
      YAML::load_file(File.join(File.dirname(__FILE__), "data", "posts.yml")).each_value do |entry| 
        begin
          post = Post.new
          post.title      = entry['title']
          post.url        = entry['url']
          post.body       = entry['body']
          post.tag_string = entry['tag_string']
          post.category   = entry['category']
          post.hits       = entry['hits']
          post.created_at = entry['created_at'] if entry['created_at']
          post.updated_at = entry['updated_at'] if entry['updated_at']
          post.user       = User.find_by_username(entry['user_id'])
          post.company    = Company.find_by_name(entry['company_id'])
          post.save!
        rescue Exception => e
          raise "Aborting migration: post '#{post.title}' #{post.errors.full_messages} #{e.message}"
        end
      end
    end
  end

  def self.down
    # raise ActiveRecord::IrreversibleMigration
  end

end
