#!/bin/bash

# clear
sudo periodic daily
sudo periodic weekly
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
