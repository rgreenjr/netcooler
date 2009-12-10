#!/usr/bin/env /Users/rgreen/code/netcooler/script/runner

company_count = Company.count
industry_count = Industry.count

1.upto(ARGV.shift.to_i) do |i|
  Company.create!(
    :name         => "Company #{company_count + i}",
    :industry_id  => rand(industry_count) + 1,
    :url          => "www.company#{company_count + i}.com/"
  )
end
