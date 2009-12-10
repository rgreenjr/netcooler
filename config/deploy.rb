# require 'mt-capistrano'

set :site,         "19175"
set :application,  "netcooler"
set :domain,       "netcooler.com"
set :webpath,      "#{domain}"
set :user,         "serveradmin%#{domain}"
set :password,     "CwA3TAHS"
set :deploy_to,    "/home/#{site}/containers/rails/#{application}" 

set :repository,   "svn+ssh://rgreen@whiskeyride.dynalias.com/Users/rgreen/svn/#{application}"
set :checkout,     "export" # export keeps from having .svn directories exposed

# set :svn_password, "xxxxxxx"
# ssh_options[:username] = user

role :web, "#{domain}"
role :app, "#{domain}"
role :db,  "#{domain}", :primary => true

task :status, :roles => :app do
  run 'mtr status'
end

task :info, :roles => :app do
  run "mtr info #{application}"
end

task :start, :roles => :app do
  run "mtr start #{application}"
end

task :stop, :roles => :app do
  run "mtr stop #{application}"
end

# task :after_update_code, :roles => :app do
#   put(File.read('config/database.yml'), "#{release_path}/config/database.yml", :mode => 0444)
# end
# 
# task :restart, :roles => :app do
#   run "mtr restart #{application} -u #{user} -p #{password}"
#   run "mtr generate_htaccess #{application} -u #{user} -p #{password}"
#   migrate
# end
