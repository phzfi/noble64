#!/bin/bash
apt-get update
apt-get -y upgrade
do-release-upgrade -f DistUpgradeViewNonInteractive
