#!/bin/bash

export DEBUG_MODE=${DEBUG_MODE:-1}
export DEBUG_RED=${CC_BG_RED}
export DEBUG_BLUE=${CC_BG_BLUE}
export DEBUG_GREEN=${CC_BG_GREEN}
export DEBUG_YELLOW=${CC_BG_YELLOW}

export DEBUG_LEVEL_1=1
export DEBUG_LEVEL_2=2
export DEBUG_LEVEL_3=3
export DEBUG_LEVEL_4=4
export DEBUG_LEVEL_5=5

mrcmd_debug_mode_init() {
  mrcmd_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_RED}" "DEBUG_MODE=${DEBUG_MODE}"

  if [[ ${DEBUG_MODE} -ge ${DEBUG_LEVEL_5} ]]; then
    set -x
  fi
}

mrcmd_debug_echo() {
  local LEVEL=${1:?}

  if [[ ${DEBUG_MODE} -ge ${LEVEL} ]]; then
    local DEBUG_CC=${2:?}
    local MESSAGE=${3:?}

    mrcmd_echo_message "${DEBUG_CC}" "[DEBUG] ${MESSAGE}"
  fi
}

mrcmd_debug_echo_call_function() {
  local FUNCTION_NAME=${1:?}
  shift

  mrcmd_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Call function: ${FUNCTION_NAME}($*)"
}
