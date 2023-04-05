#!/bin/bash

export MRCMD_SCRIPTS_LOADED_ARRAY
export MRCMD_SCRIPTS_LOADED_DIRS_ARRAY

mrcmd_scripts_call_function() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local SCRIPT_PATH=${1:?}
  shift

  local ROOT_DIR
  local SCRIPT_FUNCTION="mrcmd_func_${SCRIPT_PATH//[\/-]/_}"
  local CURRENT_PLUGIN_NAME=${SCRIPT_PATH%%/*}
  local CURRENT_PLUGINS_DIR
  local II=0
  local IS_FUNC_EXISTS

  for ROOT_DIR in "${MRCMD_DIR_ARRAY[@]}"
  do
    local PLUGINS_SRC=${MRCMD_PLUGINS_SRC_ARRAY[${II}]}
    CURRENT_PLUGINS_DIR="${ROOT_DIR}/${PLUGINS_SRC}"
    local TMP_PATH="${CURRENT_PLUGINS_DIR}/${SCRIPT_PATH}.sh"

    if [ -f "${TMP_PATH}" ]; then
      SCRIPT_PATH=${TMP_PATH}
      break
    fi

    if [[ "${II}" -eq ${CONST_DIR_PROJECT_INDEX} ]]; then # if end of MRCMD_DIR_ARRAY
      mrcmd_echo_message_error "File ${TMP_PATH} for function ${SCRIPT_FUNCTION} is not found"
      exit 1
    fi

    mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File ${TMP_PATH} for function ${SCRIPT_FUNCTION} is not found [skipped]"

    II=$((II + 1))
  done

  IS_FUNC_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

  if [[ "${IS_FUNC_EXISTS}" != true ]]; then
    # shellcheck disable=SC1090
    source "${SCRIPT_PATH}"

    IS_FUNC_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

    if [[ "${IS_FUNC_EXISTS}" != true ]]; then
      mrcmd_echo_message_error "Function ${SCRIPT_FUNCTION} is not found in ${SCRIPT_PATH}"
      exit 1
    fi

    mrcmd_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded function ${SCRIPT_FUNCTION}() from ${SCRIPT_PATH}"
  fi

  mrcmd_debug_echo_call_function "${SCRIPT_FUNCTION}" "$@"

  local OLD_CURRENT_PLUGIN_NAME=${MRCMD_CURRENT_PLUGIN_NAME}
  local OLD_CURRENT_PLUGINS_DIR=${MRCMD_CURRENT_PLUGINS_DIR}

  MRCMD_CURRENT_PLUGIN_NAME=${CURRENT_PLUGIN_NAME}
  MRCMD_CURRENT_PLUGINS_DIR=${CURRENT_PLUGINS_DIR}

  ${SCRIPT_FUNCTION} "$@"

  # clear after execute function
  MRCMD_CURRENT_PLUGIN_NAME=${OLD_CURRENT_PLUGIN_NAME}
  MRCMD_CURRENT_PLUGINS_DIR=${OLD_CURRENT_PLUGINS_DIR}
}

mrcmd_scripts_load() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  local ROOT_DIR
  local PLUGINS_SRC
  local PATH_LENGTH
  local SCRIPT_PATH
  local SCRIPT_NAME
  local II=0
  local JJ=0

  MRCMD_SCRIPTS_LOADED_ARRAY=()
  MRCMD_SCRIPTS_LOADED_DIRS_ARRAY=()

  for ROOT_DIR in "${MRCMD_DIR_ARRAY[@]}"
  do
    PLUGINS_SRC=${MRCMD_PLUGINS_SRC_ARRAY[${II}]}
    PATH_LENGTH=$((${#ROOT_DIR} + ${#PLUGINS_SRC} + 2))

    # if project scripts dir is not included
    if [[ -z "${PLUGINS_SRC}" ]]; then
      continue
    fi

    for SCRIPT_PATH in "${ROOT_DIR}/${PLUGINS_SRC}"/*
    do
      if [ -d "${SCRIPT_PATH}" ]; then
        mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Dir ${SCRIPT_PATH} ignored"
        continue
      fi

      if [[ "$(mrcmd_get_string_suffix "${SCRIPT_PATH}" 3)" != ".sh" ]]; then
        mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File ${SCRIPT_PATH} ignored"
        continue
      fi

      PATH_LENGTH=$((${#ROOT_DIR} + ${#PLUGINS_SRC} + 2))
      SCRIPT_NAME=${SCRIPT_PATH:${PATH_LENGTH}:-3}

      # shellcheck source=${SCRIPT_PATH}
      source "${SCRIPT_PATH}"

      mrcmd_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded ${SCRIPT_NAME} from ${SCRIPT_PATH}"

      if [[ "$(mrcmd_in_array "${SCRIPT_NAME}" MRCMD_SCRIPTS_LOADED_ARRAY[@])" == true ]]; then
        mrcmd_echo_message_error "Conflict: script ${SCRIPT_NAME} in ${SCRIPT_PATH} is already registered in mrcmd core [skipped]"
        continue
      fi

      MRCMD_SCRIPTS_LOADED_ARRAY[${JJ}]=${SCRIPT_NAME}
      MRCMD_SCRIPTS_LOADED_DIRS_ARRAY[${JJ}]=${II}

      JJ=$((JJ + 1))
    done

    II=$((II + 1))
  done
}
