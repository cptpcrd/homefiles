#!/usr/bin/env bash

set -e

. ~/.config/.homefiles.util.sh

arr_contains() {
    local item
    item="${1}"; shift

    while [ $# -ne 0 ]; do
        if [[ "${1}" == "${item}" ]]; then
            return 0
        fi
        shift
    done
    return 1
}

cd "${HOMEFILES_DIR}"/zsh-plugins

readarray -t plugins <plugins.txt

if [ -e plugins.local.txt ]; then
    readarray -O "${#plugins[@]}" -t plugins <'plugins.local.txt'
fi

repos=()

for plugin in "${plugins[@]}"; do
    repo="${plugin%% *}"
    [ -z "${repo}" ] && continue

    if ! arr_contains "${repo}" "${repos[@]}"; then
        repos+=("${repo}")
    fi
done

for repo in "${repos[@]}"; do
    printf '=== Updating %s ===\n' "${repo}"

    repo_path="repos/${repo//\//-SLASH-}"
    if [ -e "${repo_path}" ]; then
        (cd "${repo_path}" && git pull --ff-only)
    else
        git clone "https://github.com/${repo}" "${repo_path}"
    fi
done

for repo_path in repos/*; do
    repo="${repo_path##*/}"
    repo="${repo//-SLASH-/\/}"
    if ! arr_contains "${repo}" "${repos[@]}"; then
        # Not recognized

        # Sanity checks because rm is dangerous
        if [ -h "${repo_path}" ] || [ -d "${repo_path}" ]; then
            printf '=== REMOVING %s/%s (unrecognized) ===\n' "$(pwd)" "${repo_path}"

            if [ -h "${repo_path}" ]; then
                rm "${repo_path}"
            else
                rm -rf "${repo_path}"
            fi
        fi
    fi
done

printf '' >.plugin-cache.sh.tmp

for plugin in "${plugins[@]}"; do
    repo="${plugin%% *}"
    file_path="${plugin#* }"
    [ -z "${repo}" ] && continue
    [ -z "${file_path}" ] && continue

    repo_path="repos/${repo//\//-SLASH-}"
    printf '. %s\n' "${PWD}/${repo_path}/${file_path}" >>.plugin-cache.sh.tmp
done

mv .plugin-cache.sh.tmp .plugin-cache.sh
