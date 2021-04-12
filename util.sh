hfiles_die() {
    printf '*** Error: %s ***\n' "$@" >&2
    case "$-" in *i*) return 1;; *) exit 1;; esac
}

hfiles_realpath() {
    if [ ! -e "$1" ]; then
        return 1
    fi

    local file
    if file="$(readlink -f -- "$1" 2>/dev/null)"; then
        printf '%s\n' "${file}"
    elif file="$(realpath -- "$1" 2>/dev/null)"; then
        printf '%s\n' "${file}"
    elif file="$(grealpath -- "$1" 2>/dev/null)"; then
        printf '%s\n' "${file}"
    elif file="$(perl -e 'use Cwd "realpath"; print realpath(@ARGV[0]);' -- "$1" 2>/dev/null)"; then
        printf '%s\n' "${file}"
    else
        hfiles_die "No equivalent of 'realpath' found"
    fi
}

if [ -n "${BASH_VERSION}" ]; then
    HOMEFILES_DIR="$(dirname -- "$(hfiles_realpath "${BASH_SOURCE[0]}")")"
else
    HOMEFILES_DIR="$(dirname -- "$(hfiles_realpath "$0")")"
fi
