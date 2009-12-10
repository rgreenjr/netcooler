all = Company.find(:all)

all.each do |c|
  host = URI.parse(c.url).host rescue nil
  c.domain = host ? host.gsub(/^www\./, '') : ''
end

all.sort{|x, y| x.id <=> y.id}.each do |c|
puts "company_#{c.id}:"
puts "  id:           #{c.id}"
puts "  name:         #{c.name}"
puts "  url:          #{c.url}"
puts "  domain:       #{c.domain}"
puts "  created_at:   <%= Time.now.to_s(:db) %>"
puts "  updated_at:   <%= Time.now.to_s(:db) %>"
puts ""
end
