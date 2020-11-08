# pathutils.sh - easily manipulate $PATH or a similar colon-separated pathlist
# Pure shellscript, no external programs called.
# Works in most modern shells: bash, dash, ash, mksh
# (With zsh, you must first emulate sh/ksh)
# Author: Jo Totland <jtotland@gmail.com>

# path_has: check if an item is in $PATH or a similar colon-separated pathlist
# usage example: if path_has $PATH /foo/bin;then ... ; fi
path_has() {
    local IFS=":"
    local p
    for p in ${1}; do
        if [ "${p}" == "${2}" ]; then
            return 0
        fi
    done
    return 255
}

# path_remove: Remove items from $PATH or similiar colon-separated pathlists
# usage example: PATH=`path_remove $PATH /usr/ucb /usr/games`
path_remove() {
    local IFS=":"
    local oldpath="${1}"
    local newpath
    local p
    shift
    while [ "${#}" -ge 1 ]; do
        newpath=""
        for p in ${oldpath}; do
            if [ "${p}" != "${1}" ]; then
                if [ -z "${newpath}" ]; then newpath="${p}"
                else newpath="${newpath}:${p}"
                fi
            fi
        done
        oldpath="${newpath}"
        shift
    done
    echo "${oldpath}"
}

# path_cleanup: rm duplicates from $PATH or a similar colon-separated pathlists
# usage example: PATH=`path_cleanup $PATH`
path_cleanup() {
    local IFS=":"
    local path=""
    local p
    for p in ${1}; do
        if [ -z "${path}" ]; then
            path="${p}"
        elif ! path_has "${path}" "${p}"; then
            path="${path}:${p}"
        fi
    done
    echo "${path}"
}
