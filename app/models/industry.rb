class Industry < ActiveRecord::Base
  
  has_many :companies, :order => 'name'

  validates_presence_of   :name
  validates_uniqueness_of :name

end
