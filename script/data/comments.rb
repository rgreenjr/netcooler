#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

require 'script/data/helper'

user_count = User.count
post_count = Post.count

1.upto(ARGV.shift.to_i) do |i|
  Comment.create!(
    :user_id          => rand(user_count) + 1, 
    :commentable_id   => rand(post_count) + 1, 
    :commentable_type => "Post", 
    :body             => fake_body(20, 100)
  )
end
