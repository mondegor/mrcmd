#!/bin/bash

export APPX_DIR=.
export APPX_PLUGINS_DIR=""

export CONST_DIR_CORE_INDEX=0
export CONST_DIR_PROJECT_INDEX=1

# пути к системным плагинам и скриптам, а также к плагинам и скриптам сервиса
export MRCMD_DIR_ARRAY=("${MRCMD_DIR}" "${APPX_DIR}")
export MRCMD_PLUGINS_SRC_ARRAY=("plugins" "")

# пути к переменным сервиса
export MRCMD_DOTENV_ARRAY=("${APPX_DIR}/.env" "${APPX_DIR}/.install.env")

export TTY_INTERFACE

mrcmd_run() {
  mrcmd_check_var_required MRCMD_PLUGINS_METHOD_IS_EXECUTED

  # APPX_PLUGINS_SRC=${1}
  # APPX_SCRIPTS_SRC=${2}
  mrcmd_init "${1}" "${2}"
  shift; shift

  local CURRENT_COMMAND=${1:-help}

  case ${CURRENT_COMMAND} in

    config)
      mrcmd_plugins_exec_method config true
      ;;

    install)
      chmod +x ./mrcmd.sh
      mrcmd_plugins_exec_method install false
      ;;

    build)
      mrcmd_plugins_exec_method docker_build false
      ;;

    uninstall)
      mrcmd_plugins_exec_method uninstall false
      ;;

    help)
      mrcmd_help_exec
      ;;

    help-plugins)
      mrcmd_plugins_help_available_exec
      ;;

    help-scripts)
      mrcmd_scripts_help_available_exec
      ;;

    *)
      mrcmd_plugins_exec_method exec false "$@"

      # if command not found
      if [[ "${MRCMD_PLUGINS_METHOD_IS_EXECUTED}" != true ]]; then
        mrcmd_echo_message_error "Command ${CURRENT_COMMAND} is not found"
        mrcmd_help_exec
      fi
      ;;

  esac
}

# private
mrcmd_init() {
  mrcmd_debug_mode_init

  # APPX_PLUGINS_SRC=${1}
  # APPX_SCRIPTS_SRC=${2}
  mrcmd_init_paths "${1}" "${2}"
  mrcmd_init_dotenv
  mrcmd_init_tty_interface
  mrcmd_plugins_init
}

# private
mrcmd_init_paths() {
  local APPX_PLUGINS_SRC=${1}
  local APPX_SCRIPTS_SRC=${2}
  shift; shift

  if [ -n "${APPX_PLUGINS_SRC}" ]; then
    mrcmd_check_dir_required "Plugins" ${APPX_DIR}/${APPX_PLUGINS_SRC}

    APPX_PLUGINS_DIR="${APPX_DIR}/${APPX_PLUGINS_SRC}"
    MRCMD_PLUGINS_SRC_ARRAY[1]="${APPX_PLUGINS_SRC}"
  fi
}

# private
mrcmd_init_tty_interface() {
  local OS
  OS="$(uname -s)"
  TTY_INTERFACE=""

  # Do something under 32 bits Windows NT platform
  if [[ "${OS:0:5}" == MINGW ]]; then
    TTY_INTERFACE=winpty
  fi
}

# private
mrcmd_init_dotenv() {
  local DOTENV_FILE_PATH

  set -o allexport

  for DOTENV_FILE_PATH in "${MRCMD_DOTENV_ARRAY[@]}"
  do
    mrcmd_check_file_required "ENV" "${DOTENV_FILE_PATH}"

    # shellcheck disable=SC1090
    source "${DOTENV_FILE_PATH}"
  done

  set +o allexport
}
