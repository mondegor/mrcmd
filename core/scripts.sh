#!/bin/bash

export MRCMD_SCRIPTS_LOADED_ARRAY
export MRCMD_SCRIPTS_LOADED_DIRS_ARRAY

mrcmd_scripts_call_function() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local SCRIPT_PATH=${1:?}
  local SCRIPT_FUNCTION="${SCRIPT_PATH//[\/-]/_}"
  shift

  # if call from core or projects scripts/ dirs
  local IS_SHORT_FUNCTION=true
  local II=0
  local IS_FUNCTION_EXISTS

  if [[ "${SCRIPT_PATH}" != "${SCRIPT_PATH//\//_}" ]]; then
    IS_SHORT_FUNCTION=false
  fi

  for SCRIPT_DIR in "${MRCMD_DIR_ARRAY[@]}"
  do
      local TMP_PATH

      if [[ "${IS_SHORT_FUNCTION}" == true ]]; then
        SCRIPT_SRC=${MRCMD_SCRIPTS_SRC_ARRAY[${II}]}
        TMP_PATH="${SCRIPT_DIR}/${SCRIPT_SRC}/${SCRIPT_PATH}.sh"
      else
        TMP_PATH="${SCRIPT_DIR}/${SCRIPT_PATH}.sh"
      fi

      if [ -f "${TMP_PATH}" ]; then
        SCRIPT_PATH=${TMP_PATH}
        break
      fi

    II=$((II + 1))
  done

  if [[ "${II}" -gt ${CONST_DIR_PROJECT_INDEX} ]]; then # length of MRCMD_DIR_ARRAY
    mrcmd_echo_message_error "File ${SCRIPT_PATH}.sh is not found in mtcmd core dir`
                             ` ${MRCMD_DIR_ARRAY[${CONST_DIR_CORE_INDEX}]}/${MRCMD_SCRIPTS_SRC_ARRAY[${CONST_DIR_CORE_INDEX}]}/`
                             ` and project dir ${APPX_SCRIPTS_DIR}/"
    exit 1
  fi

  if [[ "${IS_SHORT_FUNCTION}" == true ]]; then
    SCRIPT_FUNCTION="mrcmd_scripts_${SCRIPT_FUNCTION}"
  fi

  IS_FUNCTION_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

  if [[ "${IS_FUNCTION_EXISTS}" != true ]]; then
    # shellcheck disable=SC1090
    source "${SCRIPT_PATH}"

    IS_FUNCTION_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

    if [[ "${IS_FUNCTION_EXISTS}" != true ]]; then
      mrcmd_echo_message_error "Function ${SCRIPT_FUNCTION} is not found in ${SCRIPT_PATH}"
      exit 1
    fi

    mrcmd_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded function ${SCRIPT_FUNCTION}() from ${SCRIPT_PATH}"
  fi

  mrcmd_debug_echo_call_function "${SCRIPT_FUNCTION}" "$@"

  ${SCRIPT_FUNCTION} "$@"
}

mrcmd_scripts_load() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  local SCRIPT_DIR
  local SCRIPT_SRC
  local PATH_LENGTH
  local SCRIPT_PATH
  local SCRIPT_NAME
  local II=0
  local JJ=0

  MRCMD_SCRIPTS_LOADED_ARRAY=()
  MRCMD_SCRIPTS_LOADED_DIRS_ARRAY=()

  for SCRIPT_DIR in "${MRCMD_DIR_ARRAY[@]}"
  do
    SCRIPT_SRC=${MRCMD_SCRIPTS_SRC_ARRAY[${II}]}
    PATH_LENGTH=$((${#SCRIPT_DIR} + ${#SCRIPT_SRC} + 2))

    # if project scripts dir is not included
    if [[ -z "${SCRIPT_SRC}" ]]; then
      continue
    fi

    for SCRIPT_PATH in "${SCRIPT_DIR}/${SCRIPT_SRC}"/*
    do
      if [[ "$(mrcmd_get_string_suffix "${SCRIPT_PATH}" 3)" != ".sh" ]]; then
        mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File: ${PLUGIN_PATH} [skipped]"
        continue
      fi

      PATH_LENGTH=$((${#SCRIPT_DIR} + ${#SCRIPT_SRC} + 2))
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
