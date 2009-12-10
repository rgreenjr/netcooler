class Rating < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :rateable, :polymorphic => true
  
  validates_existence_of  :user, :rateable
  validates_inclusion_of  :value, :in => [-1, 1], :message => "should be 1 or -1"

  def cool?
    value > 0
  end

  def uncool?
    value < 0
  end

end
