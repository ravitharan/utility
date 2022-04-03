export PATH=$PATH:${HOME}/utility:${HOME}/.local/bin
alias V=V.sh

set -o vi
export EDITOR=vim

source /etc/bash_completion.d/git-prompt.sh
source /etc/bash_completion.d/git-completion.bash
export GIT_PS1_SHOWDIRTYSTATE=true
PS1='\A \[\033[01;34m\]${PWD}\[\033[00m\]$(__git_ps1 " (%s)") \$ '
Title=$( echo $PWD | sed 's|^.*\(/[^/]\+\)\(/[^/]\+\)\(/[^/]\+\)$|..\1\2\3|g' )
PROMPT_COMMAND='echo -ne "\033]0;${Title}\007"'

if ! [ -f /home/ravi/.local/bin/python ]; then
    ln -s /usr/bin/python3 ${HOME}/.local/bin/python
fi
