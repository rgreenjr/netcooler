class Tag < ActiveRecord::Base

  validates_presence_of   :name
  validates_uniqueness_of :name
  validates_tag           :name
  validates_length_of     :name, :within => 2..40

  has_many :taggings do 
    def by_type(type)
      find(:all, :conditions => ["taggable_type = ?", type], :group => 'taggable_id')
    end
  end

  before_validation do |tag|
    tag.name.downcase! if tag.name
  end

  # Parses a comma separated list of tags into tag names.
  def self.parse(list)
    return list if list.is_a?(Array)
    tags = list.split(' ')
    tags.each { |t| t.strip!; t.downcase! }
    tags.uniq!
    tags.delete_if {|t| t.blank? }
    tags
  end

  # Parses comma separated tag list and returns tags for them.
  #
  #   Tag.parse_to_tags('a, b, c')
  #   # => [Tag, Tag, Tag]
  def self.parse_to_tags(list)
    find_or_create(parse(list))
  end

  # Returns Tags from an array of tag names
  #
  #   Tag.find_or_create(['a', 'b', 'c'])
  #   # => [Tag, Tag, Tag]
  def self.find_or_create(tag_names)
    transaction do
      found_tags = find(:all, :conditions => ['name IN (?)', tag_names])
      found_tags + (tag_names - found_tags.collect(&:name)).collect { |s| create!(:name => s) }
    end
  end

  def self.find_popular(options={})
    options[:limit] ||= 25
    query = "SELECT tags.*, COUNT(*) as count"
    query << " FROM tags, taggings"
    query << " WHERE tags.id = taggings.tag_id"
    # query << " AND taggings.taggable_type = '#{taggable.to_s}'" if taggable
    query << " GROUP BY tags.id"
    query << " ORDER BY count DESC"
    query << " LIMIT #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
    tags.sort
  end

  def self.find_recently_used(options={})
    options[:limit] ||= 25
    query =  "SELECT a.* FROM"
    query << " (SELECT tags.id, tags.name, COUNT(*) AS count"
    query << "   FROM tags, taggings"
    query << "   WHERE tags.id = taggings.tag_id"
    query << "   GROUP BY tags.id) a,"
    query << " (SELECT taggings.tag_id, MAX(taggings.created_at) AS created_at"
    query << "   FROM taggings"
    query << "   GROUP BY taggings.tag_id) b"
    query << " WHERE a.id = b.tag_id"
    query << " ORDER BY b.created_at DESC"
    query << " LIMIT #{options[:limit]}" if options[:limit] != nil
    tags = Tag.find_by_sql(query)
    tags.sort
  end

  def self.all_with_count(options={})
    options[:order] ||= 'name'
    query = "SELECT tags.*, COUNT(*) as count"
    query << " FROM tags, taggings"
    query << " WHERE tags.id = taggings.tag_id"
    query << " GROUP BY tags.id"
    query << " ORDER BY #{options[:order]}" if options[:order] != nil
    query << " LIMIT #{options[:limit]}" if options[:limit] != nil
    Tag.find_by_sql(query)
  end

  def <=>(comparison_object)
    name <=> comparison_object.to_s
  end

  def ==(comparison_object)
    name == comparison_object.to_s
  end

  def count
    Integer(read_attribute("count"))
  end

  def to_s()
    name
  end

  def to_param
    name
  end

end

