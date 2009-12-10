class Post < ActiveRecord::Base

  include Authorable, Rateable, Taggable

  belongs_to  :user
  belongs_to  :company#, :counter_cache => true
  has_many    :comments, :as => :commentable, :include => [:user, :ratings], :dependent => :destroy

  validates_presence_of  :title, :body, :category
  validates_existence_of :user, :company
  validates_inclusion_of :category, :in => %w( News Gossip Question )
  validates_inclusion_of :status, :in => %w( Approved Blocked )
  validates_presence_of  :url, :if => Proc.new { |post| post.news? }
  validates_url          :url, :allow_nil => true

  before_validation do |post|
    if post.gossip?
      post.url = nil if post.url.blank?
    elsif post.question?
      post.url = nil
    end
    if post.title
      post.title.strip! 
      post.title = ActionController::Base.helpers.strip_tags(post.title)
    end
    if post.body
      post.body.strip!
      post.body = ActionController::Base.helpers.strip_tags(post.body)
    end
  end
  
  before_save do |post|
    post.body_html = ActionController::Base.helpers.simple_format(post.body)
    post.body_html = ActionController::Base.helpers.auto_link(post.body_html)
  end

  def self.find_most_recent(options={})
    options[:limit] ||= 5
    query =  "SELECT posts.*"
    query << " FROM posts"
    query << " , companies" if options[:industry]
    query << " WHERE posts.status = 'Approved'"
    query << " AND posts.category = '#{options[:category]}'" if options[:category] 
    query << " AND (companies.industry_id = #{options[:industry].id} AND companies.id = posts.company_id)" if options[:industry]
    query << " GROUP BY posts.id"
    query << " ORDER BY posts.created_at DESC"
    query << " LIMIT #{options[:limit]}" 
    find_by_sql(query)
  end

  # def self.find_most_viewed(category, limit=5)
  #   find(:all, :conditions => "category = '#{category}' AND #{table_name}.status = 'Approved'", :order => 'hits DESC', :limit => limit, :include => :user)
  # end
  
  def self.search_by_category_title_and_body(category, query, limit=100)
    Post.find(:all, :conditions => ["category = ? AND (title LIKE ? OR body LIKE ?)", category, "%#{query}%", "%#{query}%"], :limit => limit)
  end

  def hit!
    self.class.increment_counter(:hits, id)
    reload
  end

  def views
    hits
  end

  def domain
    host = URI.parse(url).host rescue nil
    host ? host.gsub(/^www\./, "") : ""
  end

  def blocked?
    status == 'Blocked'
  end

  def news?
    category == 'News'
  end

  def gossip?
    category == 'Gossip'
  end

  def question?
    category == 'Question'
  end

  def to_param
    "#{id}-#{title.gsub(/[^a-z1-9]+/i, '-')}"
  end

  # should be moved to application_helper since it implies knowledge of the view URL structure
  def atom_id
    "tag:netcooler.com,#{created_at.strftime("%Y-%m-%d")}:/companies/#{company.id}/posts/#{id}"
  end
  
end
