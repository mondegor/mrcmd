#!/bin/bash

#private
CONST_AVAILABLE_PLUGIN_METHODS_ARRAY=("config" "exec" "init" "install" "uninstall" "help" "genenv")

mrcmd_plugins_help_available_exec() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_help_head
  mrcmd_plugins_available_current_value
  mrcmd_plugins_available_list
}

# private
mrcmd_plugins_available_current_value() {
  mrcmd_check_env_var_required MRCMD_PLUGINS_AVAILABLE_ARRAY
  mrcmd_check_env_var_required MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY

  local PLUGIN_NAME
  local PLUGINS

  echo -e "${CC_YELLOW}Current value of MRCMD_PLUGINS_ENABLED:${CC_END}"

  PLUGINS=$(mrcmd_plugins_available_get_core_plugins)

  if [[ -z "${PLUGINS}" ]]; then
    mrcmd_echo_message_warning "No core plugins are included"
    return
  fi

  if [[ "${MRCMD_PLUGINS_ENABLED}" == "${PLUGINS:1}" ]]; then
    mrcmd_echo_message_ok "${MRCMD_PLUGINS_ENABLED}" "  "
    return
  fi

  if [ -n "${MRCMD_PLUGINS_ENABLED}" ]; then
    mrcmd_echo_message_warning "${MRCMD_PLUGINS_ENABLED}" "  "
  else
    mrcmd_echo_message_error "All core plugins are disabled" "  "
  fi

  echo -e "For example, to enable all core plugins, you need to add to ${CC_BLUE}${MRCMD_DOTENV_ARRAY[0]}${CC_END} of project:"
  mrcmd_echo_message "${CC_BG_GRAY}" "MRCMD_PLUGINS_ENABLED=\"${PLUGINS:1}\"" "  "
}

# private
mrcmd_plugins_available_list() {
  mrcmd_check_env_var_required MRCMD_PLUGINS_AVAILABLE_ARRAY
  mrcmd_check_env_var_required MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY

  local PLUGIN_NAME
  local DIR_INDEX
  local DIR_INDEX_LAST=0
  local ROOT_DIR
  local PLUGINS_SRC
  local II=0

  for PLUGIN_NAME in "${MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  do
    DIR_INDEX=${MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY[${II}]}
    ROOT_DIR=${MRCMD_DIR_ARRAY[${DIR_INDEX}]}
    PLUGINS_SRC=${MRCMD_PLUGINS_SRC_ARRAY[${DIR_INDEX}]}

    if [[ ${II} -eq 0 ]] && [[ ${DIR_INDEX} -eq ${CONST_DIR_CORE_INDEX} ]]; then
      echo -e "${CC_YELLOW}Available core plugins:${CC_END}"
      echo ""
    fi

    if [[ ${DIR_INDEX} -ne ${DIR_INDEX_LAST} ]]; then
      DIR_INDEX_LAST=${DIR_INDEX}

      echo -e "${CC_YELLOW}Available project plugins:${CC_END}"
      echo ""
    fi

    mrcmd_plugins_available_echo_plugin "${PLUGIN_NAME}" "${ROOT_DIR}/${PLUGINS_SRC}/${PLUGIN_NAME}.sh" ${DIR_INDEX}

    II=$((II + 1))
  done
}

# private
mrcmd_plugins_available_echo_plugin() {
  local PLUGIN_NAME=${1:?}
  local PLUGIN_PATH=${2:?}
  local DIR_INDEX=${3:?}
  local PLUGIN_STATUS="${CC_LIGHT_GREEN}project${CC_END}"

  if [[ ${DIR_INDEX} -eq ${CONST_DIR_CORE_INDEX} ]]; then
    PLUGIN_STATUS="${CC_RED}disabled${CC_END}"

    if [[ "$(mrcmd_in_array "${PLUGIN_NAME}" MRCMD_PLUGINS_ENABLED_ARRAY[@])" == true ]]; then
      PLUGIN_STATUS="${CC_LIGHT_GREEN}enabled${CC_END}"
    fi
  fi

  echo -e "  ${CC_GREEN}${PLUGIN_NAME}${CC_END} in ${CC_BLUE}${PLUGIN_PATH}${CC_END} [${PLUGIN_STATUS}]:"
  mrcmd_plugins_available_echo_plugin_methods "${PLUGIN_NAME}"
}

# private
mrcmd_plugins_available_echo_plugin_methods() {
  local PLUGIN_NAME=${1:?}
  local IS_ANY_METHOD_EXISTS=false
  local PLUGIN_METHOD_NAME
  local PLUGIN_METHOD
  local IS_METHOD_EXISTS

  for PLUGIN_METHOD_NAME in "${CONST_AVAILABLE_PLUGIN_METHODS_ARRAY[@]}"
  do
    PLUGIN_METHOD="mrcmd_plugins_${PLUGIN_NAME//[\/-]/_}_method_${PLUGIN_METHOD_NAME}"
    IS_METHOD_EXISTS="$(mrcmd_function_exists "${PLUGIN_METHOD}")"

    if [[ "${IS_METHOD_EXISTS}" == true ]]; then
      echo "    - ${PLUGIN_METHOD}()"
      IS_ANY_METHOD_EXISTS=true
    else
      echo -e "    - ${CC_GRAY}${PLUGIN_METHOD}${CC_END}() [${CC_GRAY}not found${CC_END}]"
    fi
  done

  if [[ "${IS_ANY_METHOD_EXISTS}" != true ]]; then
    mrcmd_echo_message_error "Plugin ${PLUGIN_NAME} does not have any methods" "      "
  else
    echo ""
  fi
}

# private
mrcmd_plugins_available_get_core_plugins() {
  local DIR_ARRAY_INDEX
  local PLUGINS
  local II=0

  for PLUGIN_NAME in "${MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  do
    DIR_ARRAY_INDEX=${MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY[${II}]}

    if [[ ${DIR_ARRAY_INDEX} -eq ${CONST_DIR_CORE_INDEX} ]]; then
      PLUGINS="${PLUGINS} ${PLUGIN_NAME}"
    fi

    II=$((II + 1))
  done

  echo "${PLUGINS}"
  exit 0
}
