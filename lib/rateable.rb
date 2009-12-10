module Rateable
  
  def self.included(base)
    base.has_many :ratings, :as => :rateable

    def base.find_highest_rated(options={})
      options[:threshold] ||= 1
      options[:limit] ||= 5
      query =  " SELECT SUM(value) AS sum_coolness, #{self.name.pluralize}.*"
      query << " FROM ratings, #{self.name.pluralize}"
      query << " WHERE ratings.rateable_id = #{self.name.pluralize}.id"
      query << " AND ratings.rateable_type = '#{self.name}'"
      query << " GROUP BY rateable_id"
      query << " HAVING SUM(value) >= #{options[:threshold]}"
      query << " ORDER BY SUM(value) DESC"
      query << " LIMIT #{options[:limit]}" if options[:limit]
      puts query
      self.find_by_sql(query)
    end
  end

  def user_rating(user)
    return nil unless user
    ratings.find(:first, :conditions => ["user_id = ? AND rateable_id = ? AND rateable_type = ?", user.id, id, self.class.name])
  end

  def cools
    cools = ratings.count(:value, :conditions => 'value > 0')
  end

  def uncools
    ratings.count(:value, :conditions => 'value < 0')
  end

  def cool_percentage
    cools == 0 ? 0 : cools.to_f / ratings.count.to_f * 100.00
  end

  def uncool_percentage
    uncools == 0 ? 0 : uncools.to_f / ratings.count.to_f * 100.00
  end

  def coolness
    read_attribute('sum_coolness') ? Integer(read_attribute('sum_coolness')) : cools - uncools
  end

  def rate(user, value)
    value = value.to_i
    raise ArgumentError, "Illegal value: #{value}" unless value == 1 or value == -1
    rating = user_rating(user)
    if rating
      if rating.value != value
        rating.value = value
        rating.save
      else
        rating.destroy
      end
    else
      ratings << Rating.new(:user => user, :value => value)
    end
  end

end