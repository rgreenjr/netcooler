svnadmin create /Users/rgreen/svn/netcooler
cd /Users/rgreen/code/netcooler
svn import -m "initial import" . file:///Users/rgreen/svn/netcooler
cd ..
rm -rf /Users/rgreen/code/netcooler
svn checkout file:///Users/rgreen/svn/netcooler
cd netcooler

# set subversion to ignore log files
svn remove log/*
svn commit -m 'removed log files'
svn propset svn:ignore "*.log" log/
svn update log/
svn commit -m 'svn ignore new log/*.log files'

# set subversion to ignore tmp files
svn remove tmp/*
svn commit -m 'removing the temp directory from subversion'
svn propset svn:ignore "*" tmp/
svn update tmp/
svn commit -m 'svn ignore whole tmp/ directory'

# set subversion to ignore database configuration file
svn move config/database.yml config/database.orig
svn commit -m 'move database.yml to database.orig'
svn propset svn:ignore "database.yml" config/
svn update config/
svn commit -m 'Ignoring database.yml'

