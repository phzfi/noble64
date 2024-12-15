#!/bin/bash

echo "Disabling apt-daily-timer"

#See https://unix.stackexchange.com/questions/315502/how-to-disable-apt-daily-service-on-ubuntu-cloud-vm-image
sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "waiting 1 second for apt-get to die"
  sleep 1;
done

# https://askubuntu.com/questions/1059971/disable-updates-from-command-line-in-ubuntu-16-04
#sudo systemctl disable --now apt-daily{,-upgrade}.{timer,service}
#sudo systemctl disable --now apt-daily{,-upgrade}.{timer}
#sudo echo 'APT::Periodic::Update-Package-Lists "0"' > /etc/apt/apt.conf.d/20-auto-upgrades

