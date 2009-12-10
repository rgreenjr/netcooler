#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

user_count = User.count
post_count = Post.count
tag_count = Tag.count

1.upto(ARGV.shift.to_i) do |i|
  post_id = rand(post_count) + 1
  Tagging.create!(
    :user_id        => Post.find(post_id).user.id, 
    :tag_id         => rand(tag_count) + 1, 
    :taggable_id    => post_id, 
    :taggable_type  => "Post"
  )
end
