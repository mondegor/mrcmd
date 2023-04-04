#!/bin/bash

# проверяется строка на наличие только латинских символов и дефиса
mrcmd_check_file_name() {
  local FILE_NAME=${1:?}

  if [[ "${FILE_NAME}" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
    mrcmd_echo_message_error "File ${FILE_NAME} contains invalid characters"
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

mrcmd_check_var_required() {
  local VAR_NAME=${1}
  local VAR_VALUE
  eval VAR_VALUE="\$$VAR_NAME"

  if [ -z "${VAR_VALUE}" ]; then
    mrcmd_echo_message_error "Var ${VAR_NAME} is not set or empty"
    exit 1
  fi
}
