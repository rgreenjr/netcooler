class Office < ActiveRecord::Base

  belongs_to  :company
  belongs_to  :state
  belongs_to  :country
  
  validates_presence_of   :city, :country
  validates_existence_of  :state, :allow_nil => true
  validates_zip           :zip, :allow_blank => true
  
  def validate
    if country
      if !state && country.has_states?
        errors.add(:state, "can't be blank")
      elsif state && !country.has_state?(state)
        errors.add(:state, "or Province does not belong to specified country")
      end
    end
  end
  
  def state_name
    state ? state.name : ""
  end
  
  def country_name
    country ? country.name : ""
  end
  
end
