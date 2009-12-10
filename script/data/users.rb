#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

user_count = User.count

1.upto(ARGV.shift.to_i) do |i|
  User.create!(
    :username       => "user#{user_count + i}", 
    :email          => "user#{user_count + i}@example.com",
    :password       => "pass"
  )
end
