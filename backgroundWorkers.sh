# <snippet-begin 2_backgroundWorkers.sh>
backgroundWorkers () {
  debug "Setting up background workers"
  # To make the background workers start on boot
  sudo chmod +x ${PATH_TO_MISP}/app/Console/worker/start.sh

  if [ ! -e /etc/rc.local ]
  then
      echo '#!/bin/sh -e' | sudo tee -a /etc/rc.local
      echo 'exit 0' | sudo tee -a /etc/rc.local
      sudo chmod u+x /etc/rc.local
  fi

  echo "[Unit]
Description=MISP background workers
After=network.target

[Service]
Type=forking
User=${WWW_USER}
Group=${WWW_USER}
ExecStart=${PATH_TO_MISP}/app/Console/worker/start.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/misp-workers.service

  sudo systemctl daemon-reload
  sudo systemctl enable --now misp-workers

  # Add the following lines before the last line (exit 0). Make sure that you replace www-data with your apache user:
  sudo sed -i -e '$i \echo never > /sys/kernel/mm/transparent_hugepage/enabled\n' /etc/rc.local
  sudo sed -i -e '$i \echo 1024 > /proc/sys/net/core/somaxconn\n' /etc/rc.local
  sudo sed -i -e '$i \sysctl vm.overcommit_memory=1\n' /etc/rc.local
}
# <snippet-end 2_backgroundWorkers.sh>
