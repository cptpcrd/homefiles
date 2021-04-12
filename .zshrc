. ~/.sharedrc

HISTFILE=~/.zsh_history
SAVEHIST=${HISTSIZE}

setopt inc_append_history
setopt nobeep
setopt always_to_end
setopt interactive_comments
setopt no_flow_control
setopt long_list_jobs
setopt aliases

bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word

### <Prompt> ###

POWERLEVEL9K_CONTEXT_TEMPLATE="%B%F{green}%n %F{167}➜%b"
POWERLEVEL9K_ALWAYS_SHOW_USER=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(background_jobs status virtualenv context dir vcs)
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_HIDE_SIGNAME=true
POWERLEVEL9K_VCS_HG_HOOKS=()
POWERLEVEL9K_VCS_SVN_HOOKS=()
POWERLEVEL9K_VCS_HIDE_TAGS=true
POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

if [[ -n "${SSH_CONNECTION}" && -n "${SSH_TTY}" && -z "${TMUX}" ]]; then
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]})
fi

### </Prompt> ###

### <Completion> ###

autoload -U compaudit compinit
compinit

### </Completion> ###

# [ plugins.txt -ot .plugin-cache.sh ] will fail (and cause this if statement to run) if either:
# 1. .plugin-cache.sh doesn't exist
# 2. plugins.txt is newer than .plugin-cache.sh
if ! [ "${HOMEFILES_DIR}"/zsh-plugins/plugins.txt -ot "${HOMEFILES_DIR}"/zsh-plugins/.plugin-cache.sh ] 2>/dev/null; then
    zsh-plugins/update.sh
fi

. "${HOMEFILES_DIR}"/zsh-plugins/.plugin-cache.sh

if [[ -f /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found
fi

### <Bash Completion> ###

autoload -U bashcompinit
bashcompinit

alias compopt=complete

_bash_comps=(eject swapoff swapon pipenv)
for _comp in "${_bash_comps[@]}"; do
    _comp_file="/usr/share/bash-completion/completions/${_comp}"
    if [[ -f "${_comp_file}" ]]; then
        source "${_comp_file}"
    fi
done

### </Bash Completion> ###

. ~/.zsh_aliases

if [ -e ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
if [ -e ~/.zsh_aliases.local ]; then
    . ~/.zsh_aliases.local
fi
