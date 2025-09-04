#!/bin/bash
#
# This script should be run via curl:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/main/osx/all.sh)"


awk-osx-clear() {

  ## system
  echo "sudo periodic daily"
  sudo periodic daily
  
  echo "sudo periodic weekly"
  sudo periodic weekly
  
  echo "sudo periodic monthly"
  sudo periodic monthly


  ## Clear up RAM memory
  sudo purge


  ## Clear user log files
  sudo rm -rf ~/Library/Logs/*

  
  ## Remove System Logs
  sudo rm -rf /private/var/log/*
}


awk-dns-clear(){
  ## Flush DNS Cache
  sudo dscacheutil -flushcache
  sudo dscacheutil -flushcache
  sudo discoveryutil mdnsflushcache
  sudo discoveryutil udnsflushcaches
  sudo killall -HUP mDNSResponder
  lookupd -flushcache
}

awk-brew-update(){
    brew update
    brew outdated
    brew upgrade
}

awk-bins-update(){
  mkdir -p ~/bin && curl -L https://github.com/awkirin/awk-laravel-zero/releases/download/latest/awk-helper -o ~/bin/awk-helper && chmod +x ~/bin/awk-helper
}

awk-update-all(){
  awk-osx-clear
  awk-dns-clear
  awk-brew-update
  awk-bins-update
}



