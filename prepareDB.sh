# <snippet-begin 1_prepareDB.sh>
prepareDB () {
  if sudo test ! -e "/var/lib/mysql/mysql/"; then
    #Make sure initial tables are created in MySQL
    debug "Install mysql tables"
    sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    sudo service mysql start
  fi

  if sudo test ! -e "/var/lib/mysql/misp/"; then
    debug "Start mysql"
    sudo service mysql start

    debug "Setting up database"
    # Kill the anonymous users
    sudo mysql -h $DBHOST -e "DROP USER IF EXISTS ''@'localhost'"
    # Because our hostname varies we'll use some Bash magic here.
    sudo mysql -h $DBHOST -e "DROP USER IF EXISTS ''@'$(hostname)'"
    # Kill off the demo database
    sudo mysql -h $DBHOST -e "DROP DATABASE IF EXISTS test"
    # No root remote logins
    sudo mysql -h $DBHOST -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
    # Make sure that NOBODY can access the server without a password
    sudo mysqladmin -h $DBHOST -u "${DBUSER_ADMIN}" password "${DBPASSWORD_ADMIN}"
    # Make our changes take effect
    sudo mysql -h $DBHOST -e "FLUSH PRIVILEGES"

    sudo mysql -h $DBHOST -u "${DBUSER_ADMIN}" -p"${DBPASSWORD_ADMIN}" -e "CREATE DATABASE ${DBNAME};"
    sudo mysql -h $DBHOST -u "${DBUSER_ADMIN}" -p"${DBPASSWORD_ADMIN}" -e "CREATE USER '${DBUSER_MISP}'@'localhost' IDENTIFIED BY '${DBPASSWORD_MISP}';"
    sudo mysql -h $DBHOST -u "${DBUSER_ADMIN}" -p"${DBPASSWORD_ADMIN}" -e "GRANT USAGE ON *.* to '${DBUSER_MISP}'@'localhost';"
    sudo mysql -h $DBHOST -u "${DBUSER_ADMIN}" -p"${DBPASSWORD_ADMIN}" -e "GRANT ALL PRIVILEGES on ${DBNAME}.* to '${DBUSER_MISP}'@'localhost';"
    sudo mysql -h $DBHOST -u "${DBUSER_ADMIN}" -p"${DBPASSWORD_ADMIN}" -e "FLUSH PRIVILEGES;"
    # Import the empty MISP database from MYSQL.sql
    ${SUDO_WWW} cat ${PATH_TO_MISP}/INSTALL/MYSQL.sql | mysql -h $DBHOST -u "${DBUSER_MISP}" -p"${DBPASSWORD_MISP}" ${DBNAME}
  fi
}
# <snippet-end 1_prepareDB.sh>
