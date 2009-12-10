# convert CSV formated data to the YAML format

require 'rubygems'
require 'faster_csv'

FasterCSV.foreach(ARGV.first, :headers => true, :return_headers => false) do |row|
  puts "#{row[0].strip.downcase.gsub(/[^a-z1-9]+/i, '_')}:"
  puts "  name:           #{row[0].strip}"
  puts "  url:            #{row[1].strip}"
  puts "  industry:       #{row[2].capitalize}"
  puts "  description:    #{row[7].strip}" if row[7]
  puts "  ticker_symbol:  #{row[8].strip}" if row[8]

  puts "  city:           #{row[3].strip}"
  puts "  state:          #{row[4].strip}"
  puts "  street1:        #{row[5].strip}" if row[5]
  puts "  zip:            #{row[6].strip}" if row[6]
  puts ""
end
