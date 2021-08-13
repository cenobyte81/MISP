# <snippet-begin 1_apacheConfig.sh>
apacheConfig () {
  debug "Generating Apache config, if this hangs, make sure you have enough entropy (install: haveged or wait)"
  sudo cp ${PATH_TO_MISP}/INSTALL/apache.24.misp.ssl /etc/apache2/sites-available/misp-ssl.conf

  if [[ ! -z ${MISP_BASEURL} ]] && [[ "$(echo $MISP_BASEURL|cut -f 1 -d :)" == "http" || "$(echo $MISP_BASEURL|cut -f 1 -d :)" == "https" ]]; then

    echo "Potentially replacing misp.local with $MISP_BASEURL in misp-ssl.conf"

  fi

  # If a valid SSL certificate is not already created for the server,
  # create a self-signed certificate:
  sudo openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
  -subj "/C=${OPENSSL_C}/ST=${OPENSSL_ST}/L=${OPENSSL_L}/O=${OPENSSL_O}/OU=${OPENSSL_OU}/CN=${OPENSSL_CN}/emailAddress=${OPENSSL_EMAILADDRESS}" \
  -keyout /etc/ssl/private/misp.local.key -out /etc/ssl/private/misp.local.crt

  # Enable modules, settings, and default of SSL in Apache
  sudo a2dismod status
  sudo a2enmod ssl
  sudo a2enmod rewrite
  sudo a2enmod headers
  sudo a2dissite 000-default
  sudo a2ensite default-ssl

  # Apply all changes
  sudo systemctl restart apache2
  # activate new vhost
  sudo a2dissite default-ssl
  sudo a2ensite misp-ssl

  # Restart apache
  sudo systemctl restart apache2
}
# <snippet-end 1_apacheConfig.sh>
