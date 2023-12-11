export PATH=$PATH:${HOME}/utility:${HOME}/.local/bin
alias V=V.sh

set -o vi
export EDITOR=vim

#/etc/bash_completion.d/git-prompt
export GIT_PS1_SHOWDIRTYSTATE=true
PS1='\A \[\033[01;32m\]${PWD}\[\033[00m\]$(__git_ps1 " (%s)") \$ '
Title=$( echo $PWD | sed 's|^.*\(/[^/]\+\)\(/[^/]\+\)\(/[^/]\+\)$|..\1\2\3|g' )
PROMPT_COMMAND='echo -ne "\033]0;${Title}\007"'

if ! which python > /dev/null 2>&1; then
    if which python3 > /dev/null 2>&1; then
        alias python=python3
    fi
fi

alias vimdiff="vim -d"
export PYTHONPATH=${HOME}/utility
