class AssignCountriesToAllOffices < ActiveRecord::Migration

  def self.up
    Company.find(:all).each do |company|
      company.offices.each do |office|
        office.country = Country.find(office.state.country.id) if office.state
        office.save!
      end
    end
  end

  def self.down
    puts "------"
    puts "You must temporarily disable validates_presence_of :country in office.rb to reverse this migration."
    puts '------'
    Company.find(:all).each do |company|
      company.offices.each do |office|
        office.country = nil
        office.save!
      end
    end
  end

end