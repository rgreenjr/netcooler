#!/usr/local/bin/ruby -w

if ARGV.size > 1
  puts "Usage: #{File.basename($PROGRAM_NAME)} [count]"
  exit
end

count = ARGV.size == 1 ? ARGV.first.to_i : 100

def generate(model, count='')
  print "generating #{count} #{model}..."
  system "ruby script/data/#{model}.rb #{count}"
  puts "done"  
end

generate 'users',     count
generate 'companies', count
generate 'tags'
generate 'news',      count * 2
generate 'gossip',    count * 2
generate 'questions', count * 2
generate 'comments',  count * 6
generate 'ratings',   count * 10
generate 'taggings',  count * 10
