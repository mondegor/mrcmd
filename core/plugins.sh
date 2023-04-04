#!/bin/bash

export MRCMD_PLUGINS_ENABLED
export MRCMD_PLUGINS_ENABLED_ARRAY
export MRCMD_PLUGINS_LOADED_ARRAY
export MRCMD_PLUGINS_LOADED_DIRS_ARRAY
export MRCMD_PLUGINS_METHOD_IS_EXECUTED=false

mrcmd_plugins_init() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_plugins_enabled_array_init "${MRCMD_PLUGINS_ENABLED}"
  mrcmd_plugins_load
  mrcmd_plugins_exec_method init false
}

# private
mrcmd_plugins_enabled_array_init() {
  MRCMD_PLUGINS_ENABLED_ARRAY=()

  local PLUGIN_NAME
  local II=0

  # shellcheck disable=SC2048
  for PLUGIN_NAME in $*
  do
    MRCMD_PLUGINS_ENABLED_ARRAY[${II}]=${PLUGIN_NAME}
    II=$((II + 1))
  done
}

mrcmd_plugins_load() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  local PLUGIN_DIR
  local PLUGIN_SRC
  local PATH_LENGTH
  local PLUGIN_PATH
  local PLUGIN_NAME
  local II=0
  local JJ=0

  MRCMD_PLUGINS_LOADED_ARRAY=()
  MRCMD_PLUGINS_LOADED_DIRS_ARRAY=()

  for PLUGIN_DIR in "${MRCMD_DIR_ARRAY[@]}"
  do
    PLUGIN_SRC=${MRCMD_PLUGINS_SRC_ARRAY[${II}]}

    # if project plugins dir is not included
    if [[ -z "${PLUGIN_SRC}" ]]; then
      continue
    fi

    PATH_LENGTH=$((${#PLUGIN_DIR} + ${#PLUGIN_SRC} + 2))

    for PLUGIN_PATH in "${PLUGIN_DIR}/${PLUGIN_SRC}"/*
    do
      if [[ "$(mrcmd_get_string_suffix "${PLUGIN_PATH}" 3)" != ".sh" ]]; then
        mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File: ${PLUGIN_PATH} [skipped]"
        continue
      fi

      PATH_LENGTH=$((${#PLUGIN_DIR} + ${#PLUGIN_SRC} + 2))
      PLUGIN_NAME=${PLUGIN_PATH:${PATH_LENGTH}:-3}

      if [[ "${II}" -eq ${CONST_DIR_CORE_INDEX} ]] &&
         [[ "$(mrcmd_in_array "${PLUGIN_NAME}" MRCMD_PLUGINS_ENABLED_ARRAY[@])" != true ]]; then
        mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Plugin: ${PLUGIN_PATH} [skipped]"
        continue
      fi

      # shellcheck source=${PLUGIN_PATH}
      source "${PLUGIN_PATH}"

      mrcmd_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded ${PLUGIN_NAME} from ${PLUGIN_PATH}"

      if [[ "$(mrcmd_in_array "${PLUGIN_NAME}" MRCMD_PLUGINS_LOADED_ARRAY[@])" == true ]]; then
        mrcmd_echo_message_error "Conflict: plugin ${PLUGIN_NAME} in ${PLUGIN_PATH} is already registered in mrcmd core [skipped]"
        continue
      fi

      MRCMD_PLUGINS_LOADED_ARRAY[${JJ}]=${PLUGIN_NAME}
      MRCMD_PLUGINS_LOADED_DIRS_ARRAY[${JJ}]=${II}

      JJ=$((JJ + 1))
    done

    II=$((II + 1))
  done
}

# необходимо пройтись по всем плагинам и в каждом вызывать
# указанную команду, если она в нём зарегистрированна
mrcmd_plugins_exec_method() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}" "$@"
  mrcmd_check_var_required MRCMD_PLUGINS_METHOD_IS_EXECUTED

  local METHOD=${1:?}
  local IS_SHOW_HEAD=${2:?}
  shift; shift

  local IS_ANY_EXECUTED=false
  local PLUGIN_NAME
  local PLUGIN_METHOD
  local IS_METHOD_EXISTS

  for PLUGIN_NAME in "${MRCMD_PLUGINS_LOADED_ARRAY[@]}"
  do
    PLUGIN_METHOD="mrcmd_plugins_${PLUGIN_NAME//[\/-]/_}_method_${METHOD}"
    IS_METHOD_EXISTS="$(mrcmd_function_exists "${PLUGIN_METHOD}")"

    if [[ "${IS_METHOD_EXISTS}" == true ]]; then
      mrcmd_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Exec method: ${PLUGIN_METHOD}($*)"

      MRCMD_PLUGINS_METHOD_IS_EXECUTED=true

      if [[ "${IS_SHOW_HEAD}" == true ]]; then
        mrcmd_echo_message_notice "Plugin ${PLUGIN_NAME}::${METHOD}()"
      fi

      ${PLUGIN_METHOD} "$@"

      if [[ "${MRCMD_PLUGINS_METHOD_IS_EXECUTED}" == true ]]; then
        IS_ANY_EXECUTED=true
      fi
    else
      mrcmd_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Unimplemented method: ${PLUGIN_METHOD}($*) [skipped]"
    fi
  done

  MRCMD_PLUGINS_METHOD_IS_EXECUTED=${IS_ANY_EXECUTED}
}