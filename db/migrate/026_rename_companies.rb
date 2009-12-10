require 'yaml'

class RenameCompanies < ActiveRecord::Migration

  @@names = [
    ['Tricon Global Restaurants', 'Yum Brands'],
    ['Corning',                   'Dow Corning'],
    ['CNF',                       'Con-way Incorporated'],
    ['Park Place Entertainment',  'Caesars Entertainment'],
    ['Oxford Health Plans',       'United Healthcare'],
    ['York International',        'Johnson Controls'],
    ['Lucent Technologies',       'Alcatel-Lucent']
  ]

  def self.up
    Company.transaction do
      @@names.each do |a| 
        company = Company.find_by_name(a.first)
        company.update_attributes!(:name => a.last) if company
      end
    end
  end

  def self.down
    Company.transaction do
      @@names.each do |a| 
        company = Company.find_by_name(a.last)
        company.update_attributes!(:name => a.first) if company
      end
    end
  end

end
