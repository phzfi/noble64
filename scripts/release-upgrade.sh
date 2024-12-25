#!/bin/bash
apt-get update
apt-get -y upgrade
apt install -y linux-headers-generic linux-headers-virtual linux-image-virtual linux-virtual sosreport
do-release-upgrade -f DistUpgradeViewNonInteractive
