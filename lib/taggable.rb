module Taggable
  
  def self.included(base)
    base.has_many :tags, :through => :taggings, :order => "name"   
    base.has_many :taggings, :as => :taggable
    base.after_save :save_tags
    base.extend ClassMethods
  end
    
  def tag_string=(str)
    @tag_string = str
  end

  def tag_string
    @tag_string ||= tags.collect { |t| t.name }.join(' ')
  end
  
  protected
  
  def before_validation
    return if @tag_string.nil?
    Tag.parse(@tag_string).each do |name|
      tag = Tag.new(:name => name)
      errors.add_to_base("Tag '#{tag.name}' #{tag.errors.on(:name)}") if !tag.valid? and tag.errors.on(:name) != "has already been taken"
    end
    return errors.empty?
  end
  
  # This method is called after the Taggable object has been saved but not commited.
  # The Tagging.set_on method will raise and exception if there is a problem
  # parsing @tag_string or saving the individual Tags. Only if it returns
  # successfully will the Taggable object, tags and taggings be committed.
  def save_tags
    Tagging.set_on(self, @tag_string) if @tag_string
    @tag_string = nil
  end

  module ClassMethods
    def find_tagged_with(list)
      find(:all, :select => "#{table_name}.*", 
           :from => "#{table_name}, tags, taggings", 
           :conditions => ["#{table_name}.#{primary_key} = taggings.taggable_id AND taggings.taggable_type = ? AND taggings.tag_id = tags.id AND tags.name IN (?)", name, Tag.parse(list)],
           :group => "#{table_name}.#{primary_key}")
    end
  end

end
