
# Environment
export TMP=/tmp
export TEMP=/tmp
export PATH=$PATH:~/node_modules/elm/binwrappers

function jobs_count {
    cnt=$(jobs -l | wc -l)
    if [ $cnt -gt 0 ]; then
        echo -ne "[\\033[00;31m${cnt}\\033[0m] "
    fi
}

# --- posh-git-bash --- #
# (see https://github.com/lyze/posh-git-sh )
source ~/git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "\u@\h:\w" "\n`jobs_count`λ ";'$PROMPT_COMMAND


# --- Useful Git aliases and functions --- #
alias g='git'
alias d='git diff -w'
alias dm='git diff -w master..'
alias dmo='git diff --name-only master..'
alias lm='git log master..'
alias gmt='git mergetool'
alias grc='git rebase --continue'
alias gst='git status'

glf() {
  git ls-files *$1*
}

gg() {
  git grep -i --heading --line-number $@
}

