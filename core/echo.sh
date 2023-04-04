#!/bin/bash

mrcmd_echo_message_ok() {
  mrcmd_echo_message "${CC_BG_GREEN}" "${1:?}" "${2}"
}

mrcmd_echo_message_notice() {
  mrcmd_echo_message "${CC_BG_BLUE}" "${1:?}" "${2}"
}

mrcmd_echo_message_warning() {
  mrcmd_echo_message "${CC_BG_YELLOW}" "${1:?}" "${2}"
}

mrcmd_echo_message_error() {
  mrcmd_echo_message "${CC_BG_RED}" "${1:?}" "${2}"
}

mrcmd_echo_message() {
  local CC_COLOR=${1:?}
  local MESSAGE=${2:?}
  local INDENT=${3}
  local LENGTH=$((${#MESSAGE} + 3))

  echo ""
  echo -en "${INDENT}${CC_COLOR}"
  mrcmd_repeat_string " " ${LENGTH}
  echo -e "${CC_END}"

  echo -e "${INDENT}${CC_COLOR} ${MESSAGE}  ${CC_END}"

  echo -en "${INDENT}${CC_COLOR}"
  mrcmd_repeat_string " " ${LENGTH}
  echo -e "${CC_END}"
  echo ""
}

mrcmd_echo_var() {
  local VAR_NAME=${1}
  local VAR_VALUE
  eval VAR_VALUE="\$$VAR_NAME"

  echo -en "${CC_YELLOW}\$${VAR_NAME} = ${CC_END}"

  if [ -n "${VAR_VALUE}" ]; then
    echo -e "${CC_BLUE}${VAR_VALUE}${CC_END}"
  else
    echo -e "${CC_RED}NULL${CC_END}"
  fi
}

mrcmd_echo_var_boolean() {
  local VAR_NAME=${1}
  local VAR_VALUE
  eval VAR_VALUE="\$$VAR_NAME"

  echo -en "${CC_YELLOW}\$${VAR_NAME} = ${CC_END}"

  if [[ "${VAR_VALUE}" == true ]]; then
    echo -e "${CC_GREEN}true${CC_END}"
  else
    echo -e "${CC_RED}false${CC_END}"
  fi
}
