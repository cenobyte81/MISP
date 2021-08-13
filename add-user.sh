# <snippet-begin add-user.sh>
## FIXME: This function is a duplicate included in: # <snippet-begin 0_support-functions.sh>
# check is /usr/local/src is RW by misp user
checkUsrLocalSrc () {
  echo ""
  if [[ -e /usr/local/src ]]; then
    WRITEABLE=$(sudo -H -u $MISP_USER touch /usr/local/src 2> /dev/null ; echo $?)
    if [[ "$WRITEABLE" == "0" ]]; then
      echo "Good, /usr/local/src exists and is writeable as $MISP_USER"
    else
      # TODO: The below might be shorter, more elegant and more modern
      #[[ -n $KALI ]] || [[ -n $UNATTENDED ]] && echo "Just do it" 
      sudo chmod 2775 /usr/local/src
      sudo chown root:staff /usr/local/src
    fi
  else
    echo "/usr/local/src does not exist, creating."
    mkdir -p /usr/local/src
    sudo chmod 2775 /usr/local/src
    # TODO: Better handling /usr/local/src permissions
    if [[ "$(cat /etc/group |grep staff > /dev/null 2>&1)" == "0" ]]; then
      sudo chown root:staff /usr/local/src
    fi
  fi
}
# <snippet-end add-user.sh>
