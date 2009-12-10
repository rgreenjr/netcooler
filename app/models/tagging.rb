class Tagging < ActiveRecord::Base

  belongs_to :user
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true

  validates_existence_of :user, :tag, :taggable

  # Sets the tags on the taggable object.  Only adds new tags and deletes old tags.
  #
  # Tagging.set_on(taggable, 'foo, bar')
  #
  def self.set_on(taggable, tag_list)
    new_tags = Tag.parse_to_tags(tag_list)
    delete_from(taggable, (taggable.tags - new_tags))
    add_to(taggable, new_tags)
  end

  # Deletes tags from the taggable object
  #
  # Tagging.delete_from(taggable, [1, 2, 3])
  # Tagging.delete_from(taggable, [Tag, Tag, Tag])
  #
  def self.delete_from(taggable, tags)
    if tags.any?
      list = tags.collect { |t| t.is_a?(Tag) ? t.id : t }
      delete_all(['user_id = ? AND taggable_id = ? AND taggable_type = ? AND tag_id IN (?)', taggable.user_id, taggable.id, taggable.class.base_class.name, list])
    end
  end

  # Adds tags to the taggable object
  #
  # Tagging.add_to(taggable, [Tag, Tag, Tag])
  #
  def self.add_to(taggable, tags)
    (tags - taggable.tags).each { |tag| create!(:user_id => taggable.user_id, :taggable => taggable, :tag => tag) } unless tags.empty?
  end

end

