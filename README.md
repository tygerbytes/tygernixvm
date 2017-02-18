# Fussy Tyger (My adhoc Linux config management)

## Usage
1. Create a bare metal Ubuntu Linux VM
1. Install Git and clone this repo
1. Run `./bootstrap`, which will install some packages, including `rvm` and `Ruby`. Then it will automatically run `/.update.rb`, which will copy or patch the configuration files.

Later, you can run `./update.rb` by itself if all you did was update a config file.

## Future plans.
Currently, this script isn't very smart, but it speeds up provisioning a new VM to my liking. If I get some time, I'll look into using Ansible, or a Bash alternative like Turtle. For now, the script isn't that complex, so something like Ansible would probably be overkill..
