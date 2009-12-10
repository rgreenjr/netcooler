class AddIndustries < ActiveRecord::Migration

  def self.up
    ['Consumer Goods', 'Transportation', 'Media', 'Hospitality', 'Construction'].each { |name| Industry.create!(:name => name) }
    Industry.find_by_name('Utilities').update_attributes!(:name => 'Energy')
  end

  def self.down
    ['Consumer Goods', 'Transportation', 'Media', 'Hospitality', 'Construction'].each { |name| Industry.find_by_name(name).destroy }
    Industry.find_by_name('Energy').update_attributes!(:name => 'Utilities')
  end

end
