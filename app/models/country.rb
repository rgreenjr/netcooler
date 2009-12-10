class Country < ActiveRecord::Base
  
  has_many :states
  
  def self.all_by_name
    find(:all, :order => 'name')
  end
  
  def self.default
    find_by_name("United States")
  end
  
  def has_states?
    State.count(:conditions => ["country_id = ?", self.id]) != 0
  end
  
  def has_state?(state)
    self.id == state.country_id
  end
  
end
