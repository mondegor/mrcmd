
mrcore_import "${MRCMD_DIR}/src/plugins/methods.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-echo-call-function.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_plugins_exec_single_method_if_empty_test() {
  local errorCode
  local isSampleShown=false

  function mrcore_echo_sample {
    isSampleShown=true
  }

  ################################################################################

  if mrcmd_plugins_exec_SINGLE_method "pluginName" "" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]] || [[ "${isSampleShown}" != true ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_system_test() {
  function mrcore_lib_in_array() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_exec_method() {
    if [[ "${2:?}" == "pluginName" ]] && [[ "${3:?}" == "pluginMethod" ]]; then
      ${RETURN_TRUE}
    fi

    ${RETURN_FALSE}
  }

  ################################################################################

  if ! mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_not_system_test() {
  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_method() {
    if [[ "${2:?}" != "pluginName" ]] || [[ "${3:?}" != "${MRCMD_PLUGIN_METHOD_EXECUTE}" ]]; then
      ${RETURN_FALSE}
    fi
  }

  ################################################################################

  if ! mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_plugins_exec_single_method_if_not_implemented_test() {
  local errorCode
  local isSampleShown=false

  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_method() {
    ${RETURN_FALSE}
  }

  function mrcore_echo_sample {
    isSampleShown=true
  }

  ################################################################################

  if mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]] || [[ "${isSampleShown}" != true ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_single_method_if_unknown_command_test() {
  local errorCode
  local isSampleShown=false

  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_method() {
    ${RETURN_UNKNOWN_COMMAND}
  }

  function mrcore_echo_sample {
    isSampleShown=true
  }

  ################################################################################

  if mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_COMMAND} ]] || [[ "${isSampleShown}" != true ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_single_method_if_unknown_error_test() {
  local errorCode
  local isSampleShown=false

  function mrcore_lib_in_array() {
    ${RETURN_FALSE}
  }

  function mrcmd_plugins_exec_method() {
    ${RETURN_UNKNOWN_ERROR}
  }

  function mrcore_echo_sample {
    isSampleShown=true
  }

  ################################################################################

  if mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_ERROR} ]] || [[ "${isSampleShown}" != false ]]; then
      ${EXIT_ERROR}
    fi
  fi
}
