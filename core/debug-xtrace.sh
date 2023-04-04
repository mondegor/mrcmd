#!/bin/bash

#private
MRCMD_XTRACE_STORED=false

mrcmd_xtrace_store_and_off() {
  if [[ "${MRCMD_XTRACE_STORED}" == true ]]; then
    echo -e "${CC_BG_RED} Need to call method mrcmd_xtrace_restore before! ${CC_END}"
    exit 1
  fi

  if [ -o xtrace ]; then
    set +x
    MRCMD_XTRACE_STORED=true
  fi
}

mrcmd_xtrace_restore() {
  if [[ "${MRCMD_XTRACE_STORED}" == true ]]; then
    set -x
    MRCMD_XTRACE_STORED=false
  fi
}
