# <snippet-begin 0_installCoreDeps.sh>
installCoreDeps () {
  debug "Installing core dependencies"
  # Install the dependencies: (some might already be installed)
  sudo apt-get install curl gcc git gpg-agent make python python3 openssl redis-server sudo vim zip unzip virtualenv libfuzzy-dev sqlite3 moreutils -qy

  # Install MariaDB (a MySQL fork/alternative)
  sudo apt-get install mariadb-client mariadb-server -qy

  # Install Apache2
  sudo apt-get install apache2 apache2-doc apache2-utils -qy

  # install Mitre's STIX and its dependencies by running the following commands:
  sudo apt-get install python3-dev python3-pip libxml2-dev libxslt1-dev zlib1g-dev python-setuptools -qy
}
# <snippet-end 0_installCoreDeps.sh>

# <snippet-begin 0_installDepsPhp74.sh>
# Install Php 7.4 dependencies
installDepsPhp74 () {
  debug "Installing PHP 7.4 dependencies"
  PHP_ETC_BASE=/etc/php/7.4
  PHP_INI=${PHP_ETC_BASE}/apache2/php.ini
  checkAptLock
  sudo apt install -qy \
  libapache2-mod-php7.4 \
  php7.4 php7.4-cli \
  php7.4-dev \
  php7.4-json php7.4-xml php7.4-mysql php7.4-opcache php7.4-readline php7.4-mbstring php7.4-zip \
  php7.4-redis php7.4-gnupg \
  php7.4-intl php7.4-bcmath \
  php7.4-gd

  for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
  do
      sudo sed -i "s/^\($key\).*/\1 = $(eval echo \${$key})/" $PHP_INI
  done
  sudo sed -i "s/^\(session.sid_length\).*/\1 = $(eval echo \${session0sid_length})/" $PHP_INI
  sudo sed -i "s/^\(session.use_strict_mode\).*/\1 = $(eval echo \${session0use_strict_mode})/" $PHP_INI
}
# <snippet-end 0_installDepsPhp74.sh>
