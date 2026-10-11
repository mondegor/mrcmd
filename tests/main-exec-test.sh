mrcore_import "${MRCMD_DIR}/src/main.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_main_exec_if_empty_test() {
  local errorCode

  if mrcmd_main_exec ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_main_exec_if_unknown_command_test() {
  local errorCode

  MRCMD_PLUGINS_LOADED_ARRAY=()

  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  ################################################################################

  if mrcmd_main_exec "unknownCommand" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_main_exec_if_unknown_plugin_test() {
  local errorCode

  MRCMD_PLUGINS_LOADED_ARRAY=()

  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  ################################################################################

  if mrcmd_main_exec "help" "unknownPlugin" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_main_exec_if_plugin_method_failed_test() {
  local errorCode

  MRCMD_PLUGINS_LOADED_ARRAY=("pluginName")

  function mrcore_lib_in_array() {
    if [[ "${1:?}" == "pluginName" ]] && [[ "${2:?}" == "MRCMD_PLUGINS_LOADED_ARRAY[@]" ]]; then
      ${RETURN_TRUE}
    fi

    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_SINGLE_method() {
    ${RETURN_UNKNOWN_ERROR}
  }

  ################################################################################

  if mrcmd_main_exec "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_ERROR} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_main_exec_if_plugin_command_unknown_test() {
  local errorCode

  MRCMD_PLUGINS_LOADED_ARRAY=("pluginName")

  function mrcore_lib_in_array() {
    if [[ "${1:?}" == "pluginName" ]] && [[ "${2:?}" == "MRCMD_PLUGINS_LOADED_ARRAY[@]" ]]; then
      ${RETURN_TRUE}
    fi

    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_SINGLE_method() {
    ${RETURN_UNKNOWN_COMMAND}
  }

  ################################################################################

  if mrcmd_main_exec "pluginName" "unknownCommand" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_COMMAND} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}
