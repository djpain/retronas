#!/bin/bash

set -u

_CONFIG=/opt/retronas/dialog/retronas.cfg
source $_CONFIG
source ${DIDIR}/common.sh
cd ${DIDIR}

rn_get_dirs() {
  COUNT=2
  cd "${OLDRNPATH}"
  find . -maxdepth 1 -type d | sed 's#^\./##g' | grep -v ^\.$ | sort | while read PATHITEM
  do
    echo "${PATHITEM}" "${PATHITEM}"
    COUNT=$((${COUNT}+1))
  done
}

rn_fix_perms() {
  cd ${DIDIR}

  local MENU_ARRAY=(
    1 "Exit to main menu"
    $(rn_get_dirs)
  )

  # Append directory items
  #DIRS=$(rn_get_dirs)
  #COUNT=01
  #for DIR in ${DIRS[@]}
  #do
  #  MENU_ARRAY+=($((++COUNT)) "$DIR")
  #done

  local MENU_BLURB="\nPlease choose a directory below ${OLDRNPATH} to fix. \
  \n\nThis will reset all the file ownership to the user \"${OLDRNUSER}\" \
  \n\nPlease be careful, as this is irreversible.  If unsure, exit now."

  DLG_MENU "Fix Permissions" $MENU_ARRAY 5 "${MENU_BLURB}" 
}

CLEAR
rn_fix_perms
case ${CHOICE} in
  1)
    exit 1
    ;;
  *)
    CLEAR
    chown -Rc ${OLDRNUSER}:${OLDRNUSER} "${OLDRNPATH}/${CHOICE}"
    chmod -Rc a-st,u+rwX,g+rwX,o+rX "${OLDRNPATH}/${CHOICE}"
    ;;
esac
