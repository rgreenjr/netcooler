class AssignCountryIdToStates < ActiveRecord::Migration

  extend MigrationHelpers
  
  def self.up
    usa = Country.find_by_name("United States")
    State.find(:all).each do |state|
      state.country = usa
      state.save!
    end
    add_fk :states, :country_id, :countries
  end

  def self.down
    drop_fk :states, :country_id
    State.find(:all).each do |state|
      state.country = nil
      state.save!
    end
  end

end
