#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/wsl2-set-dns.sh)"

sudo rm /etc/resolve.conf
sudo echo "nameserver 10.1.1.1" > /etc/resolve.conf
sudo chattr +i /etc/resolv.conf