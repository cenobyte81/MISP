# <snippet-begin 4_kafka.sh>
installKafka () {
  sudo apt-get install librdkafka-dev php-dev -y
  sudo pecl channel-update pecl.php.net
  sudo pecl install rdkafka
  echo "extension=rdkafka.so" | sudo tee ${PHP_ETC_BASE}/mods-available/rdkafka.ini
  sudo phpenmod rdkafka
  sudo service apache2 restart
}
# <snippet-end 4_kafka.sh>
