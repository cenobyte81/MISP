# <snippet-begin 2_logRotation.sh>
logRotation () {
  # MISP saves the stdout and stderr of its workers in ${PATH_TO_MISP}/app/tmp/logs
  # To rotate these logs install the supplied logrotate script:
  sudo cp ${PATH_TO_MISP}/INSTALL/misp.logrotate /etc/logrotate.d/misp
  sudo chmod 0640 /etc/logrotate.d/misp
}
# <snippet-end 2_logRotation.sh>
