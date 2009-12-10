# create database netcooler_development character set utf8;
# create database netcooler_test        character set utf8;
# create database netcooler_production  character set utf8;
  
# GRANT ALL PRIVILEGES ON netcooler_development.* TO 'rgreen'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;
# GRANT ALL PRIVILEGES ON netcooler_test.*        TO 'rgreen'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;
# GRANT ALL PRIVILEGES ON netcooler_production.*  TO 'rgreen'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;

# change root password
mysqladmin -u root password NEWPASSWORD

# login into MySQL as root and execute the following
GRANT ALL PRIVILEGES ON *.*  TO 'rgreen'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;

# then exit MySQL and execute the following from the shell
rake db:create:all