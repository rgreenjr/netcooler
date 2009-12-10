require 'rubygems'
require 'fastercsv'

csv_path = ARGV.first
country = File.basename(csv_path, '.csv')
yml_path = File.dirname(csv_path) + "/#{country}.yml"
str = ""

FasterCSV.foreach(csv_path) do |row|
  str <<  "#{row[0].strip.downcase.gsub(/[^\w]/, '_')}:\n"
  str <<  "  name: #{row[0].strip}\n"
  str <<  "  abbreviation: #{row[0].strip}\n"
  str <<  "  country_name: #{country}\n\n"
end

File.open(yml_path, 'w') {|f| f.puts str}