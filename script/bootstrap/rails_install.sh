#!/bin/sh

mkdir src
cd src

# Readline
curl -O ftp://ftp.gnu.org/gnu/readline/readline-5.1.tar.gz
tar xzvf readline-5.1.tar.gz
cd readline-5.1
./configure --prefix=/usr/local
make
sudo make install
cd ..

# Ruby
curl -O ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.4.tar.gz
tar xzvf ruby-1.8.4.tar.gz 
cd ruby-1.8.4
./configure --prefix=/usr/local --enable-pthread --with-readline-dir=/usr/local
make
sudo make install
cd ..

# RubyGems
curl -O http://rubyforge.org/frs/download.php/5207/rubygems-0.8.11.tgz
tar xzvf rubygems-0.8.11.tgz
cd rubygems-0.8.11
sudo /usr/local/bin/ruby setup.rb
cd ..

# Rails
sudo gem install rails --include-dependencies

# FCGI
curl -O http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz
tar xzvf fcgi-2.4.0.tar.gz
cd fcgi-2.4.0
./configure --prefix=/usr/local
make
sudo make install
cd ..

# Ruby-FastCGI bindings
curl -O http://sugi.nemui.org/pub/ruby/fcgi/ruby-fcgi-0.8.6.tar.gz
tar xzvf ruby-fcgi-0.8.6.tar.gz
cd ruby-fcgi-0.8.6
/usr/local/bin/ruby install.rb config --prefix=/usr/local
/usr/local/bin/ruby install.rb setup
sudo /usr/local/bin/ruby install.rb install
cd ..
sudo gem install fcgi

# PCRE library
curl -O ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-6.6.tar.gz
tar xzvf pcre-6.6.tar.gz
cd pcre-6.6
./configure --prefix=/usr/local CFLAGS=-O1
make
sudo make install
cd ..

# LightTPD
curl -O http://lighttpd.net/download/lighttpd-1.4.11.tar.gz
tar xzvf lighttpd-1.4.11.tar.gz
cd lighttpd-1.4.11
./configure --prefix=/usr/local --with-pcre=/usr/local
make
sudo make install
cd ..

# manually install MySQL then run next line optionally
# sudo gem install mysql -- --with-mysql-dir=/usr/local/mysql