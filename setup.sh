apt-get install lua5.3 lua5.3-dev luarocks redis tasksel php-pear

tasksel install lamp-server

# todo: add redis to systemd
# sed -i /

systemctl restart redis

echo "set test \"Hello World from Redis\"" | redis-cli

pecl download php-lua
tar xvf php-lua*.tgz
cd php-lua*

phpize
./configure --with-lua-version=5.3
make
cp modules/lua.so / #todo

# todo add extension=lua to [cli|apache2]/php.info

systemctl restart apache2

rm /var/www/html/index.html
cp index.php /var/www/html/index.php
cp index.lua /var/www/html/index.lua
