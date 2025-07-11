#!/bin/bash
#
# This script should be run via curl:
#   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/osx/clear.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

# clear
echo "sudo periodic daily"
sudo periodic daily

echo "sudo periodic weekly"
sudo periodic weekly

echo "sudo periodic monthly"
sudo periodic monthly

## Clear up RAM memory
#sudo purge
#
## Flush DNS Cache
#sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;
#
## Clear user log files
#sudo rm -rf ~/Library/Logs/*
#
## Remove System Logs
#sudo rm -rf /private/var/log/*
