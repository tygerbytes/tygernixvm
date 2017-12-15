#!/bin/bash

function message {
  PURPLE='\033[0;35m'
  COLOR_OFF='\033[0m'
  echo -e "${PURPLE}$1${COLOR_OFF}"
}
export -f message

function minutes_since_file_updated()
{
    local file_to_check="${1}"
    local aptDate="$(stat -c %Y ${file_to_check})"
    local nowDate="$(date +'%s')"
    local seconds_since_update=$((nowDate - aptDate))
    echo "$((seconds_since_update / 60))"    

}

function apt_update()
{
    message "== Make sure packages are up-to-date."
    local minutes_since_update="$(minutes_since_file_updated '/var/cache/apt/pkgcache.bin')"
    local minutes_since_sources_changed="$(minutes_since_file_updated '/etc/apt/sources.list')"
    local updateInterval=$((24 * 60))
    if [[ "${minutes_since_update}" -gt "${updateInterval}" ]] || [[ "${minutes_since_sources_changed}" -lt "${minutes_since_update}" ]]
    then
        message '|>\t - Updating'
        sudo apt-get update
    else
        message "|>\t - Refreshed ${minutes_since_update} minutes ago. No need to update."
    fi
}

function update_rvm() {
    message "|>\t - Installing/upgrading rvm"
    message " (Don't forget to configure terminal to \"Run command as a logon shell\")"
    sudo apt-get install -y rvm
}



# Install some packages required to add the Docker apt repo
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common


# Add package sources
message "== Add some apt package sources"

message "|>\t - Docker"
message "|>\t\t - Add Docker's official GPG key"
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
message "|>\t\t - Add repo"
sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"

message "|>\t - Node.js"
curl -sL https://deb.nodesource.com/setup_8.x | grep -v 'apt-get update' | sudo -E bash -

message "|>\t - RVM"
sudo apt-add-repository -y ppa:rael-gc/rvm


# Now that we've added our package repos, run `apt-get update`
apt_update


message '===Bootstrap Ruby==>'
message  "== Checking rvm"
if ! which rvm
then
    update_rvm
    message "!!!Log out and back in. Then run this script again. (Required for rvm to work properly)"
    exit 1
else
    update_rvm
fi

message "== Ensure Ruby installed"
rvm install ruby --latest
bash -l -c "rvm use ruby --latest"

message "== Install some useful gems"
gem install --no-document bundler pry colorize

message "== Install Docker"
sudo apt-get install -y docker-engine

message "== Install Docker Compose"
message "|>\t - Resolving latest version from GitHub"
LATEST_COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
message "|>\t\t - Latest version is ${LATEST_COMPOSE_VERSION}" 
message "|>\t - Installing"
sudo curl -L "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

message "== Install Docker Compose bash completion"
sudo curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

message "== Install pip and aws cli"
sudo apt install python-pip -y
message "|> Upgrade pip"
pip install --upgrade pip
message "|> Install aws command line interface"
pip install --upgrade --user awscli


message "== Install Node.js"
sudo apt-get install -y nodejs build-essential

message "== Install Elm"
pushd .
cd ~
npm install elm
sudo npm install -g elm-live
sudo npm install -g elm-test
sudo npm install -g elm-oracle
popd
sudo cp bin/elm-format /usr/local/bin
sudo chmod +x /usr/local/bin/elm-format

message "== Install Stack"
curl -sSL https://get.haskellstack.org/ | sh

message "|>\t - Update Stack"
stack update

message "== Install Turtle"
stack install turtle

message "== Install diff-so-fancy"
sudo npm install -g diff-so-fancy

message "== Install some miscellaneous packages"
sudo apt-get install -y \
    fonts-hack-ttf \
    xclip

message "== Remove any uneeded packages"
sudo apt-get autoremove -y

message "== Clone Vim-config repo"
if [ -d "$HOME/.vim/.git" ]; then
    pushd .
    cd ~/.vim
    git pull
    git submodule update --recursive
    popd
else
    rm -rf $HOME/.vim
    git clone --recursive https://github.com/tygerbytes/vim-config.git ~/.vim && ~/.vim/setup.sh
fi

git clone --recursive https://github.com/tygerbytes/vim-config.git ~/.vim && ~/.vim/setup.sh

message "== Grab git-prompt.sh"
wget https://raw.githubusercontent.com/lyze/posh-git-sh/f90fcc9a8d4ec93f1ed3fa0196974f7ab4ef0140/git-prompt.sh

# Now that we've bootstrapped Ruby,
#  pass control to the Ruby-based update script
message "== Running update.rb"
./update.rb
