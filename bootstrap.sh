#!/bin/bash

function message {
  PURPLE='\033[0;35m'
  COLOR_OFF='\033[0m'
  echo -e "${PURPLE}$1${COLOR_OFF}"
}
export -f message

function hoursSinceAptGetUpdate()
{
    local aptDate="$(stat -c %Y '/var/cache/apt/pkgcache.bin')"
    local nowDate="$(date +'%s')"
    local seconds_since_update=$((nowDate - aptDate))
    echo "$((seconds_since_update / 60 / 60))"    
}



message '==Bootstrap Ruby==>'
function update_rvm {
    message "\t - Adding apt repository for rvm"
    sudo apt-add-repository -y ppa:rael-gc/rvm
    message "\t - refresh apt packages"
    local hours_since_update="$(hoursSinceAptGetUpdate)"
    local updateInterval=24
    if [[ "${hours_since_update}" -gt "${updateInterval}" ]]
    then
        sudo apt-get update
    else
        message "\t\t - Refreshed ${hours_since_update} hours ago. Update aborted."
    fi
    message "\t - Installing/upgrading rvm (Don't forget to configure terminal to \"Run command as a logon shell\")"
    sudo apt-get install -y rvm
}

message  "-- Checking rvm"
if ! which rvm
then
    update_rvm
    message "!!!Log out and back in. Then run this script again. (Required for rvm to work properly)"
    exit
else
    update_rvm
fi

message "-- Ensure Ruby installed"
rvm install ruby --latest
rvm use ruby --latest

message "-- Install some useful gems"
gem install --no-document bundler pry

message "<== Done bootstrapping Ruby"


message "--Install some packages"
sudo apt-get install -y fonts-hack-ttf

message "--Remove any uneeded packages"
sudo apt-get autoremove -y


# Now that we've bootstrapped Ruby,
#  pass control to the Ruby-based update script
message "-- Running update.rb"
./update.rb

