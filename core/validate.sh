#!/bin/bash

export CONST_PATTERN_FILE_NAME="^[a-zA-Z0-9_.-]+$"
export CONST_PATTERN_FILE_PREFIX="^[a-zA-Z0-9-]+$"

mrcmd_check_value_required() {
  local CAPTION=${1:?}
  local STR=${2}

  if [ -z "${STR}" ]; then
    mrcmd_echo_message_error "${CAPTION} is required"
    exit 1
  fi
}

mrcmd_check_name() {
  local CAPTION=${1:?}
  local PATTERN=${2:?}
  local STR=${3:?}

  if [[ ! "${STR}" =~ ${PATTERN} ]]; then
    mrcmd_echo_message_error "${CAPTION} \"${STR}\" contains invalid characters, allowed characters: ${PATTERN}"
    exit 1
  fi
}

mrcmd_check_dir_required() {
  local CAPTION=${1:?}
  local DIR_PATH=${2:?}

  if [ ! -d "${DIR_PATH}" ]; then
    mrcmd_echo_message_error "[${CAPTION}] Dir ${DIR_PATH} is not found"
    exit 1
  fi
}

mrcmd_check_file_required() {
  local CAPTION=${1:?}
  local FILE_PATH=${2:?}

  if [ ! -f "${FILE_PATH}" ]; then
    mrcmd_echo_message_error "[${CAPTION}] File ${FILE_PATH} is not found"
    exit 1
  fi
}

mrcmd_check_env_var_required() {
  local VAR_NAME=${1}
  local VAR_VALUE
  eval VAR_VALUE="\$$VAR_NAME"

  if [ -z "${VAR_VALUE}" ]; then
    mrcmd_echo_message_error "Var ${VAR_NAME} is not set or empty"
    exit 1
  fi
}
