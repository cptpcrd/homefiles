. ~/.sharedrc

HISTFILE=~/.bash_history
HISTCONTROL=ignoreboth
HISTFILESIZE=${HISTSIZE}
shopt -s histappend

shopt -s checkwinsize

if [[ $- == *i* ]]; then
    bind '"\e[1;5D" backward-word'
    bind '"\e[1;5C" forward-word'

    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'

    bind '"\e[3;5~":kill-word'
    bind '"\C-H":backward-kill-word'
fi

COLOR_PROMPT='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
NOCOLOR_PROMPT='\u@\h:\w\$ '

if [ "${COLORTERM}" = truecolor ]; then
    PS1="${COLOR_PROMPT}"
else
    PS1="${NOCOLOR_PROMPT}"
fi

case "${TERM}" in
    xterm*|rxvt*)
        PS1="\[\e]0;\u@\h: \w\a\]${PS1}"
        ;;
esac

if ! shopt -oq posix; then
    for _path in /usr/local/share/bash-completion/bash_completion /usr/pkg/share/bash-completion/bash_completion /usr/share/bash-completion/bash_completion /etc/bash_completion; do
        if [[ -f "${_path}" ]]; then
            . "${_path}"
            break
        fi
    done
fi

. ~/.bash_aliases

if [ -e ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
if [ -e ~/.bash_aliases.local ]; then
    . ~/.bash_aliases.local
fi
