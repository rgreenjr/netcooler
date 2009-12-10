class State < ActiveRecord::Base
  
  belongs_to :country

  validates_presence_of   :name, :abbreviation
  validates_uniqueness_of :name, :abbreviation

  def self.all_by_name
    State.find(:all, :order => 'name')
  end
  
end
