#!/bin/bash
# -*- mode: sh; coding: utf-8 -*-
ME="${0##*/}"

CACHEDIR=~/.cache/memx

TTL=3600

umask 0027

[[ -d "${CACHEDIR}" ]] || mkdir -p "${CACHEDIR}"

my_sha256 () {
  printf "${*}" | sha256sum \
  | ( read DIGEST REST; echo "${DIGEST}"; )
}

DIGEST=$(my_sha256 "${@}")
SUBDIR="${CACHEDIR}/${DIGEST}"

CMDLINE="${SUBDIR}/cmdline"
STDOUT="${SUBDIR}/stdout"
STDERR="${SUBDIR}/stderr"
RCFILE="${SUBDIR}/rc"

[[ -d "${SUBDIR}" ]] && {
  MODIFIED=$(stat --format='%Y' "${SUBDIR}")
  NOW=$(date '+%s')
  [[ $((NOW-MODIFIED)) -gt ${TTL} ]] && rm -rf "${SUBDIR}"
}
[[ ! -d "${SUBDIR}" ]] && mkdir -p "${SUBDIR}"

[[ ! -f "${STDOUT}" ]] && {
  [[ ! -f "${STDERR}" ]] && {
    eval "${@}" >"${STDOUT}" 2>"${STDERR}"
    echo "${@}" >"${CMDLINE}"  # FIXME: error in quoted arguments
    echo "${?}" >"${RCFILE}"
  }
}

[[ -s "${STDOUT}" ]] && cat "${STDOUT}"
[[ -s "${STDERR}" ]] && cat "${STDERR}" >&2
[[ -s "${RCFILE}" ]] && {
  read RC <"${RCFILE}"
  exit ${RC}
}

: exit successfully
# eof
