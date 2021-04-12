. ~/.shared_aliases

alias rehash='hash -r'

### <Git aliases> ###

# COPIED FROM OHMYZSH #
# https://github.com/ohmyzsh/ohmyzsh/blob/0ab87c26c17171ae6162ff379a0c704fa57dff2e/lib/git.zsh

function git_current_branch() {
  local ref
  ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# END COPIED FROM OHMYZSH #

# COPIED FROM OHMYZSH #
# https://github.com/ohmyzsh/ohmyzsh/blob/0ab87c26c17171ae6162ff379a0c704fa57dff2e/plugins/git/git.plugin.zsh

git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local branch
    for branch in main trunk; do
        if command git show-ref -q --verify refs/heads/$branch; then
            echo $branch
            return
        fi
    done
    echo master
}

alias ga='git add'
alias gc='git commit -v'

alias gsb='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'

alias gsh='git show'
alias glg='git log --stat'

alias gsta='git stash push'
alias gstl='git stash list'
alias gsts='git stash show --text'
alias gstp='git stash pop'
alias gstd='git stash drop'

alias grh='git reset'
alias grhh='git reset --hard'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gb='git branch'

alias gr='git remote'
alias gf='git fetch'
alias gm='git merge'
alias gl='git pull'
alias gp='git push'
alias glum='git pull upstream $(git_main_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias ggsup='git push --set-upstream origin $(git_current_branch)'

alias glr='git pull --rebase'

alias glu='git pull upstream'
alias glud='git pull upstream dev'
alias gludr='git pull --rebase upstream dev'

alias gcd='git checkout dev'
alias grbd='git rebase dev'
alias grbud='git rebase upstream/dev'
alias grbum='git rebase upstream/$(git_main_branch)'

# END COPIED FROM OHMYZSH #

### </Git aliases> ###
