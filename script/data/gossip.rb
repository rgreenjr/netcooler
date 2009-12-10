#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

require 'script/data/helper'

user_count = User.count
company_count = Company.count
gossip_count = Post.find_by_category("Gossip").size rescue 0

1.upto(ARGV.shift.to_i) do |i|
  Post.create!(
    :user_id    => rand(user_count) + 1, 
    :company_id => rand(company_count) + 1, 
    :category   => "Gossip",
    :title      => fake_title,
    :url        => "http://www.example.com/path",
    :body       => fake_body
  )
end
