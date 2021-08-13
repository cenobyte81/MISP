# <snippet-begin 1_installCake.sh>
installCake () {
  debug "Installing CakePHP"
  # Make composer cache happy
  # /!\ composer on Ubuntu when invoked with sudo -u doesn't set $HOME to /var/www but keeps it /home/misp \!/
  sudo mkdir -p /var/www/.composer ; sudo chown ${WWW_USER}:${WWW_USER} /var/www/.composer
  ${SUDO_WWW} sh -c "cd ${PATH_TO_MISP}/app ;php composer.phar install"

  # Enable CakeResque with php-redis
  sudo phpenmod redis
  sudo phpenmod gnupg

  # To use the scheduler worker for scheduled tasks, do the following:
  ${SUDO_WWW} cp -fa ${PATH_TO_MISP}/INSTALL/setup/config.php ${PATH_TO_MISP}/app/Plugin/CakeResque/Config/config.php

  # If you have multiple MISP instances on the same system, don't forget to have a different Redis per MISP instance for the CakeResque workers
  # The default Redis port can be updated in Plugin/CakeResque/Config/config.php
}
# <snippet-end 1_installCake.sh>
