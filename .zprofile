# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"

export PATH="$PATH:${HOME}/bin"

if [ -f .lando.yml ]; then
    alias php="lando php"
    alias composer="lando composer"
    alias wp="lando wp"
    alias yarn="lando yarn"
    alias acorn="lando wp acorn"
fi

docker_ansible="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -v "$SSH_AUTH_SOCK:/ssh-agent" -e "SSH_AUTH_SOCK=/ssh-agent" -w /apps alpine/ansible"
alias ansible="${docker_ansible} ansible"
alias ansible-playbook="${docker_ansible} ansible-playbook"


alias tproxy="all_proxy=socks5://127.0.0.1:9050"
alias tbproxy="all_proxy=socks5://127.0.0.1:9150"

export VAULT_ADDR='http://127.0.0.1:8200'


alias php81="$(brew --prefix php@8.1)/bin/php"
alias php82="$(brew --prefix php@8.2)/bin/php"
alias php83="$(brew --prefix php@8.3)/bin/php"
alias php84="$(brew --prefix php@8.4)/bin/php"
alias php="php82"






#!/bin/bash
# source <(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/main/osx/all.sh)


# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"

export PATH="$PATH:${HOME}/bin"

export VAULT_ADDR='http://127.0.0.1:8200'

alias tproxy="all_proxy=socks5://127.0.0.1:9050"
alias tbproxy="all_proxy=socks5://127.0.0.1:9150"

alias php81="$(brew --prefix php@8.1)/bin/php"
alias php82="$(brew --prefix php@8.2)/bin/php"
alias php83="$(brew --prefix php@8.3)/bin/php"
alias php84="$(brew --prefix php@8.4)/bin/php"
alias php="php82"

# ansible
docker_ansible="docker run -ti --rm -v ~/.ssh:/root/.ssh -v ~/.aws:/root/.aws -v $(pwd):/apps -v "$SSH_AUTH_SOCK:/ssh-agent" -e "SSH_AUTH_SOCK=/ssh-agent" -w /apps alpine/ansible"
alias ansible="${docker_ansible} ansible"
alias ansible-playbook="${docker_ansible} ansible-playbook"

#if [ -f .lando.yml ]; then
#    alias php="lando php"
#    alias composer="lando composer"
#    alias wp="lando wp"
#    alias yarn="lando yarn"
#    alias acorn="lando wp acorn"
#fi


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
