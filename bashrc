
# Environment
export TMP=/tmp
export TEMP=/tmp
export PATH=$PATH:~/node_modules/elm/binwrappers

nocolor="\\[\\e[0m\\]"
red="\\[\\e[00;31m\\]"
blue="\\[\\e[00;34m\\]"

function jobs_count {
    cnt=$(jobs -l | wc -l)
    if [ $cnt -gt 0 ]; then
        echo -ne "[$red${cnt}$nocolor] "
    fi
}

function lamda_prompt {
    echo -ne "$blueλ$nocolor "
}

# --- posh-git-bash --- #
# (see https://github.com/lyze/posh-git-sh )
source ~/git-prompt.sh
PROMPT_COMMAND='__posh_git_ps1 "\u@\h:\w" "\n`jobs_count``lamda_prompt`";'$PROMPT_COMMAND

# awscli completion
complete -C '$HOME/.local/bin/aws_completer' aws

# --- Aliases --- #
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias v='vim'

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

if ! ps -U "$USER" -o pid,ucomm | grep -q gpg-agent; then
    eval $(gpg-agent --daemon)
fi

export GPG_TTY=$(tty)

if [ "$COLORTERM" == "gnome-terminal" ] || [ "$COLORTERM" == "xfce4-terminal" ]; then
    TERM=xterm-256color
elif [ "$COLORTERM" == "rxvt-xpm" ]; then
    TERM=rxvt-256color
fi

EDITOR=vim

