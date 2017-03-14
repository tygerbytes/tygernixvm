# Fussy Tyger (My adhoc Linux config management)

## Usage
1. Create a bare metal Ubuntu Linux VM
1. Install Git and clone this repo with the `--recursive` flag
  - `git clone --recursive git@github.com:tygerbytes/FussyTyger.git`
1. Run `./bootstrap.sh`, which will install some packages, including `rvm` and `Ruby`. Then it will automatically run `/.update.rb`, which will copy or patch the configuration files.

Later, you can run `./update.rb` by itself if all you did was update a config file.

## Future plans.
Currently, this script isn't very smart, but it speeds up provisioning a new VM to my liking. If I get some time, I'll look into using Ansible, or a Bash alternative like Turtle. For now, the script isn't that complex, so something like Ansible would probably be overkill..

## Acknowledgements
 - [posh-git-bash](https://github.com/lyze/posh-git-sh)
 - [node-test-runner] (https://github.com/rtfeldman/node-test-runner)
 - [elm-oracle] (https://github.com/elmcast/elm-oracle)
 - [elm-format] (https://github.com/avh4/elm-format)
 - [vim-plug] (https://github.com/junegunn/vim-plug)
