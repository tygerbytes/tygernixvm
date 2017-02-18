#!/bin/bash

function message {
  PURPLE='\033[0;35m'
  COLOR_OFF='\033[0m'
  echo -e "${PURPLE}$1${COLOR_OFF}"
}

function update_rvm {
  message " - Adding apt repository"
  sudo apt-add-repository -y ppa:rael-gc/rvm
  sudo apt-get update
  sudo apt-get install -y rvm
}

message  "-- Checking rvm"
if ! which rvm
then
  update_rvm
  message "Log out and back in. Then run update again."
  exit
else
  update_rvm
fi

message "-- Ensure Ruby installed"
rvm install ruby --latest
rvm use ruby --latest

gem install --no-document bundler pry

# Now that we've bootstrapped Ruby,
#  pass control to the Ruby-based update script
./update.rb

