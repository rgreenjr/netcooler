class Company < ActiveRecord::Base
  
  belongs_to  :industry
  has_many    :offices, :dependent => :destroy

  has_many :posts, :dependent => :destroy do
    def most_recent(category, limit=10)
      find(:all, :conditions => "category = '#{category}' AND status != 'Blocked'", :order => "created_at DESC", :limit => limit)
    end
  end

  validates_presence_of   :name, :industry
  validates_existence_of  :industry, :allow_nil => true
  validates_uniqueness_of :domain
  validates_url           :url
  
  before_validation do |company|
    unless company.url.blank?
      company.url.strip!
      company.url = "http://#{company.url}" unless company.url =~ %r{^http://}
      company.domain = extract_domain(company.url)
    end
  end
  
  def self.find_newest(limit=10)
    find(:all, :order => "created_at DESC", :limit => limit)
  end
  
  def self.search_by_name(query, limit=100)
    Company.find(:all, :conditions => ["name LIKE ?", "%#{query}%"], :limit => limit, :include => 'offices')
  end

  def self.search_by_name_and_city_and_state(q, limit=100)
    query =  <<-SQL
    SELECT companies.*
    FROM companies, offices, states
    WHERE (offices.city = ? OR states.name = ? OR companies.name LIKE ?)
    AND states.id = offices.state_id
    AND companies.id = offices.company_id
    ORDER BY companies.name
    SQL
    Company.find_by_sql([query, q, q, "%#{q}%"])
  end

  def self.find_by_city(city)
    query =  "SELECT companies.*"
    query << " FROM companies, offices"
    query << " WHERE companies.id = offices.company_id"
    query << " AND offices.city = ?"
    query << " ORDER BY companies.name"
    Company.find_by_sql([query, city])
  end
  
  def self.find_by_state(state)
    query =  "SELECT companies.*"
    query << " FROM companies, offices, states"
    query << " WHERE companies.id = offices.company_id"
    query << " AND states.id = offices.state_id"
    query << " AND states.name = ?"
    query << " ORDER BY companies.name"
    Company.find_by_sql([query, state])
  end
  
  def self.find_by_country(country)
    query =  "SELECT companies.*"
    query << " FROM companies, offices, countries"
    query << " WHERE companies.id = offices.company_id"
    query << " AND countries.id = offices.country_id"
    query << " AND countries.name = ?"
    query << " ORDER BY companies.name"
    Company.find_by_sql([query, country])
  end
  
  def self.find_by_city_and_state(city, state)
    query =  "SELECT companies.*"
    query << " FROM companies, offices, states"
    query << " WHERE companies.id = offices.company_id"
    query << " AND offices.city = ?"
    query << " AND states.id = offices.state_id"
    query << " AND states.name = ?"
    query << " ORDER BY companies.name"
    Company.find_by_sql([query, city, state])
  end
  
  def tags
    query = "SELECT tag.id, tag.name, COUNT(*) AS count"
    query << " FROM ("
    query << "   SELECT tags.*, posts.company_id"
    query << "     FROM tags, posts, taggings"
    query << "     WHERE posts.id = taggings.taggable_id"
    query << "     AND tags.id = taggings.tag_id AND posts.company_id = #{id}"
    query << " ) tag"
    query << " GROUP BY tag.name"
    Tag.find_by_sql(query)
  end
  
  def main_address
    offices.empty? ? "" : "#{city}, #{state_name}"
  end
  
  def city
    offices.empty? ? "" : offices.first.city
  end

  def state_name
    offices.empty? ? "" : offices.first.state_name
  end

  def country_name
    offices.empty? ? "" : offices.first.country_name
  end

  # should be moved to application_helper since it implies knowledge of the view URL structure
  def atom_id
    "tag:netcooler.com,#{created_at.strftime("%Y-%m-%d")}:/companies/#{id}"
  end

  private
  
  def self.extract_domain(url)
    host = URI.parse(url).host rescue nil
    host ? host.gsub(/^www\./, "") : ""
  end

end
