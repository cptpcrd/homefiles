#!/usr/bin/env bash

force=
while getopts "fh" opt; do
    case "${opt}" in
        f)
            force=y
            ;;
        h|*)
            echo "Usage: $0 [-f]"
            echo
            echo "Options:"
            echo "  -f: Force installation (rename existing files to <fname>.old)."
            echo "      USE WITH CARE."
            exit 1
            ;;
    esac
done

set -e
shopt -s extglob

cd "$(dirname "${BASH_SOURCE[0]}")"
. util.sh

reldir_home() {
    homedir="$(hfiles_realpath "${HOME}")"
    if [[ "$1" != "${homedir}"/* ]]; then
        hfiles_die "Bad path '${1}' -- resolved to a directory outside \$HOME"
    fi

    printf '%s' "${1#"${homedir}"/}"
}

get_prefix() {
    local dir homedir
    dir="$(reldir_home "$(hfiles_realpath ~/"${1%/*}")")"

    while [ "${dir}" != . ]; do
        dir="$(dirname "${dir}")"
        printf '../'
    done
}

HOMEFILES_RELDIR="$(reldir_home "${HOMEFILES_DIR}")"

cd "${HOMEFILES_DIR}"

git pull || hfiles_die "Error updating from git"

UTILSH_PATH=~/.config/.homefiles.util.sh
if [ -e "${UTILSH_PATH}" ]; then
    target="$(readlink -- "${UTILSH_PATH}")"
    if [ "${target}" != "${HOMEFILES_DIR}"/util.sh ]; then
        hfiles_die "${UTILSH_PATH} points to the wrong location (${target} instead of ${HOMEFILES_DIR}/util.sh); either fix it or remove it"
    fi
else
    mkdir -p "${UTILSH_PATH%/*}"
    ln -s "${HOMEFILES_DIR}"/util.sh "${UTILSH_PATH}"
    printf '%s -> %s\n' "${UTILSH_PATH}" "${HOMEFILES_DIR}"/util.sh
fi

fnames=(
    .bash_profile
    .bashrc
    .bash_aliases
    .zshrc
    .zsh_aliases
    .sharedrc
    .shared_aliases
    .gitconfig
    .gitignore_global
    .vimrc
    bin/*
)

for fname in "${fnames[@]}"; do
    # Remove any number of trailing slashes
    fname="${fname%%+(\/)}"

    prefix=''
    case "${fname}" in
    */*)
        # TODO:
        # 1. Create nonexistent directories
        # 2. Handle the relative paths (i.e. add '../' prefixes to the target of the symlink)
        mkdir -p ~/"${fname%/*}"
        prefix="$(get_prefix "${fname%/*}")"
        ;;
    esac

    if [ -h ~/"${fname}" ]; then
        continue
    elif [ -e ~/"${fname}" ]; then
        # If we weren't given -f, skip it
        if [ -z "${force}" ]; then continue; fi

        printf '*** Moving %s/%s to %s/%s.old ...\n' "${HOME}" "${fname}" "${HOME}" "${fname}"
        mv "${HOME}/${fname}"{,.old}
    fi

    ln -s "${prefix}${HOMEFILES_RELDIR}/${fname}" ~/"${fname}" || hfiles_die "Error creating symlink"
    printf '%s -> %s\n' ~/"${fname}" "${prefix}${HOMEFILES_RELDIR}/${fname}"
done

zsh-plugins/update.sh || hfiles_die "Error updating ZSH plugins"
