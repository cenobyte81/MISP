# <snippet-begin 2_permissions.sh>
# Main function to fix permissions to something sane
permissions () {
  debug "Setting permissions"
  sudo chown -R ${WWW_USER}:${WWW_USER} ${PATH_TO_MISP}
  sudo chmod -R 750 ${PATH_TO_MISP}
  sudo chmod -R g+ws ${PATH_TO_MISP}/app/tmp
  sudo chmod -R g+ws ${PATH_TO_MISP}/app/files
  sudo chmod -R g+ws ${PATH_TO_MISP}/app/files/scripts/tmp
}
# <snippet-end 2_permissions.sh>
