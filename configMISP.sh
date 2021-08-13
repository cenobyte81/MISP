# <snippet-begin 2_configMISP.sh>
configMISP () {
  debug "Generating ${LBLUE}MISP${NC} config files"
  # There are 4 sample configuration files in ${PATH_TO_MISP}/app/Config that need to be copied
  ${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/bootstrap.default.php ${PATH_TO_MISP}/app/Config/bootstrap.php
  ${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/database.default.php ${PATH_TO_MISP}/app/Config/database.php
  ${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/core.default.php ${PATH_TO_MISP}/app/Config/core.php
  ${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/config.default.php ${PATH_TO_MISP}/app/Config/config.php

  echo "<?php
  class DATABASE_CONFIG {
          public \$default = array(
                  'datasource' => 'Database/Mysql',
                  //'datasource' => 'Database/Postgres',
                  'persistent' => false,
                  'host' => '$DBHOST',
                  'login' => '$DBUSER_MISP',
                  'port' => 3306, // MySQL & MariaDB
                  //'port' => 5432, // PostgreSQL
                  'password' => '$DBPASSWORD_MISP',
                  'database' => '$DBNAME',
                  'prefix' => '',
                  'encoding' => 'utf8',
          );
  }" | ${SUDO_WWW} tee ${PATH_TO_MISP}/app/Config/database.php

  # Important! Change the salt key in ${PATH_TO_MISP}/app/Config/config.php
  # The salt key must be a string at least 32 bytes long.
  # The admin user account will be generated on the first login, make sure that the salt is changed before you create that user
  # If you forget to do this step, and you are still dealing with a fresh installation, just alter the salt,
  # delete the user from mysql and log in again using the default admin credentials (admin@admin.test / admin)

  # and make sure the file permissions are still OK
  sudo chown -R ${WWW_USER}:${WWW_USER} ${PATH_TO_MISP}/app/Config
  sudo chmod -R 750 ${PATH_TO_MISP}/app/Config
}
# <snippet-end 2_configMISP.sh>
