
mrcore_import "${MRCMD_DIR}/src/plugins/methods.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-constants.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-echo.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_plugins_exec_method_if_not_exists_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_FALSE}
  }

  function mrcmd_plugins_lib_get_plugin_method_name() {
    echo ""
  }

  ################################################################################

  if mrcmd_plugins_exec_method SINGLE "pluginName" "pluginMethod" "false" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_FALSE} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_exists_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_lib_get_plugin_method_name() {
    echo "mrcmd_plugins_pluginName_method_pluginMethodExists"
  }

  function mrcmd_plugins_exec_method_head() {
    return
  }

  function mrcmd_plugins_pluginName_method_pluginMethodExists() {
    return
  }

  ################################################################################

  if ! mrcmd_plugins_exec_method SINGLE "pluginName" "pluginMethod" "false" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_unknown_command_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_lib_get_plugin_method_name() {
    echo "mrcmd_plugins_pluginName_method_pluginMethodWithErrorUnknownCommand"
  }

  function mrcmd_plugins_exec_method_head() {
    return
  }

  function mrcmd_plugins_pluginName_method_pluginMethodWithErrorUnknownCommand() {
    ${RETURN_UNKNOWN_COMMAND}
  }

  ################################################################################

  if mrcmd_plugins_exec_method SINGLE "pluginName" "pluginMethod" "false" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_COMMAND} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_unknown_error_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_lib_get_plugin_method_name() {
    echo "mrcmd_plugins_pluginName_method_pluginMethodWithErrorUnknownError"
  }

  function mrcmd_plugins_exec_method_head() {
    return
  }

  function mrcmd_plugins_pluginName_method_pluginMethodWithErrorUnknownError() {
    ${RETURN_UNKNOWN_ERROR}
  }

  ################################################################################

  if mrcmd_plugins_exec_method SINGLE "pluginName" "pluginMethod" "false" ; then
    ${EXIT_ERROR}
  else
    errorCode="$?"

    if [[ "${errorCode}" -ne ${ERROR_CODE_UNKNOWN_ERROR} ]]; then
      ${EXIT_ERROR}
    fi
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_call_head_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_lib_get_plugin_method_name() {
    echo "mrcmd_plugins_pluginName_method_pluginMethodExistsWithHead"
  }

  function mrcmd_plugins_exec_method_head() {
    if [[ "${1:?}" == "pluginName" ]] && [[ "${2:?}" == "pluginMethodExistsWithHead" ]]; then
      ${RETURN_TRUE}
    fi

    ${RETURN_FALSE}
  }

  function mrcmd_plugins_pluginName_method_pluginMethodExistsWithHead() {
    return
  }

  ################################################################################

  if ! mrcmd_plugins_exec_method "pluginName" "pluginMethodExistsWithHead" "true" ; then
    ${EXIT_ERROR}
  fi
}
