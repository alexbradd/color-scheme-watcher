#/bin/bash
#
# color-scheme-watcher.sh, a simple script to watch for changes to 'color-scheme'
# Copyright (C) 2023  Alexadnru Gabriel Bradatan (alexbradd)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

MYNAME="color-scheme-watcher.sh"
MYVER="23.05.0"
HELP="$(cat <<EOF
Usage: $MYNAME [options]...

Watch for changes to org.gnome.desktop.interface color-scheme and execute
scriplets.

Scriplets are little programs executed from XDG_DATA_HOME/color-scheme-watcher if
defined, otherwise from ~/.local/share/color-scheme-watcher. They will receive
as input one parameter depending on the value of 'color-scheme': 'light',
'dark' or 'default'.

Options:
  -h  --help                     Show this message
      --version                  Show version
  -v  --verbose                  Be verbose when writing to stdout
  -d  --scripletdir <dir>        Use specified scriplet directory
EOF
)"

GSETTINGS_PATH="org.gnome.desktop.interface"
SCRIPTLETS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/color-scheme-watcher"
VERBOSE=

log() {
  if [ -n "$VERBOSE" ]; then
    echo "$1" 1>&2
  fi
}

iter_scriptlets() {
  local out=
  for s in $SCRIPTLETS_DIR/*; do
    log ">>> Executing $s"
    out="$($s $1)"
    if [ $? -eq 0 ]; then
      log "$out"
    else
      log "$out"
      log ">>> Scriplet encountered an error"
    fi
  done
}

do_case() {
    case "$1" in
      "color-scheme: 'prefer-dark'")
        log ">>> Executing scriptlets with 'dark'"
        iter_scriptlets "dark"
        return 0 ;;
      "color-scheme: 'prefer-light'")
        log ">>> Executing scriptlets with 'light'"
        iter_scriptlets "light"
        return 0 ;;
      "color-scheme: 'default'")
        log ">>> Executing scriptlets with 'default'"
        iter_scriptlets "default"
        return 0 ;;
      *)
        log ">>> Invalid value '$line' read... This might be a bug, please report it"
        return 1 ;;
    esac
}

watch_gsettings() {
  while read -r line; do
    log ">>> Read change"
    do_case "$line" || exit $?
  done < <(gsettings monitor $GSETTINGS_PATH color-scheme)
}

OPTS=$(getopt -n "$MYNAME" \
              -o hvd: \
              --long help,version,verbose,scriptletdir: -- "$@")
if [ "$?" -ne 0 ]; then
  echo "Incorrect options"
  exit 1
fi
eval set -- "$OPTS"
while true; do
  case "$1" in
    -h|--help)
      echo "$HELP"
      exit 0 ;;
    --version)
      echo "Version $MYVER"
      exit 0 ;;
    -v|--verbose)
      VERBOSE=1 ;;
    -d|--scriptletdir)
      shift
      SCRIPTLETS_DIR="$1" ;;
    --)
      break ;;
    *)
      echo "Unrecognized option '$1'"
      exit 1 ;;
  esac
  shift
done

do_case "color-scheme: $(gsettings get $GSETTINGS_PATH color-scheme)" && \
  watch_gsettings
