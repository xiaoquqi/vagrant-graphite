#!/bin/bash

CURRENT_PATH=$(cd $(dirname $0); pwd)
VAGRANT_PATH="/vagrant"
MYSQL_PASSWORD="sysadmin"

sudo apt-get update

# Graphite Installation
sudo debconf-set-selections <<< "graphite-carbon graphite-carbon/postrm_remove_databases boolean false"
sudo apt-get install -y graphite-web graphite-carbon

# MySQL Installation & Configuration
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"
sudo apt-get install -y mysql-server python-mysqldb

# Graphite Configuration
mysql -uroot -p$MYSQL_PASSWORD << EOF
CREATE DATABASE IF NOT EXISTS graphite default charset utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON graphite.* TO graphite@"localhost" identified by 'graphite';
FLUSH PRIVILEGES;
EOF

sudo cp $VAGRANT_PATH/scripts/local_settings.py /etc/graphite/local_settings.py

sudo graphite-manage syncdb --noinput

# Cabon Configuration
sed -i 's/^CARBON_CACHE_ENABLED=false/CARBON_CACHE_ENABLED=true/g' /etc/default/graphite-carbon

sed -i 's/^ENABLE_LOGROTATION = False/ENABLE_LOGROTATION = True/g' /etc/carbon/carbon.conf

sudo cp /usr/share/doc/graphite-carbon/examples/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf

sudo service carbon-cache start

# Apache Configuration
sudo apt-get install apache2 libapache2-mod-wsgi

sudo a2dissite 000-default
sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
sudo a2ensite apache2-graphite
sudo service apache2 reload

# Install Diamond & Grafana
sudo apt-get install -y python-support
URL='http://200.21.0.30/softwares/linux/diamond_4.0.57_all.deb'; FILE=`mktemp`; wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE
cp /etc/diamond/diamond.conf.example /etc/diamond/diamond.conf
sed -i 's/# interval = 300/interval = 10/g' /etc/diamond/diamond.conf

sudo apt-get install -y nodejs npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
URL='http://200.21.0.30/softwares/linux/grafana_2.0.2_amd64.deb'; FILE=`mktemp`; wget "$URL" -qO $FILE && sudo dpkg -i $FILE; rm $FILE
sudo update-rc.d grafana-server defaults 95 10
sudo service grafana-server start
