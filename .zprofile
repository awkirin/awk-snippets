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