#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

user_count = User.count
post_count = Post.count
comment_count = Comment.count

1.upto(ARGV.shift.to_i) do |i|
  Rating.create!(
    :user_id        => rand(user_count) + 1, 
    :rateable_id    => rand(post_count) + 1, 
    :rateable_type  => "Post", 
    :value          => [-1, 1].at(rand(2))
  )

  Rating.create!(
    :user_id        => rand(user_count) + 1, 
    :rateable_id    => rand(comment_count) + 1, 
    :rateable_type  => "Comment", 
    :value          => [-1, 1].at(rand(2))
  )
end
