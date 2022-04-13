#!/bin/sh

if [ `id -u` != 0 ]; then
   echo "Please run this script as root" 
   exit 1
fi

# Install depdendencies
apt-get install lua5.3 lua5.3-dev luarocks redis tasksel php-pear php7.4-dev

# Install a LAMP server because it's easy
tasksel install lamp-server

# Configure Redis to use Ubuntu's SystemD
sed -i 's/supervised no/supervised systemd/g' /etc/redis/redis.conf
systemctl restart redis
echo "set test \"Hello World from Redis\"" | redis-cli

# Setup the php-lua module
pecl channel-update pecl.php.net
pecl download lua
tar xvf lua-*.tgz
cd lua-*
phpize
./configure --with-lua-version=5.3
make
cp modules/lua.so /usr/lib/php/20190902/lua.so
cd -

# Setup the redis-lua module
luarocks install redis-lua

# Configure Apache2
echo "; configuration for Lua module" > /etc/php/7.4/mods-available/lua.ini
echo "; priority=20" >> /etc/php/7.4/mods-available/lua.ini
echo "extension=lua.so" >> /etc/php/7.4/mods-available/lua.ini
ln -s /etc/php/7.4/mods-available/lua.ini /etc/php/7.4/apache2/conf.d/20-lua.ini
ln -s /etc/php/7.4/mods-available/lua.ini /etc/php/7.4/cli/conf.d/20-lua.ini
rm /var/www/html/index.html
cp index.php /var/www/html/index.php
cp index.lua /var/www/html/index.lua
systemctl restart apache2

# Test the whole thing:
wget -q -O /dev/stdout http://localhost?i=wat
