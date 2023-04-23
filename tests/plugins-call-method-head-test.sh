
mrcore_import "${MRCMD_DIR}/src/plugins/methods.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-constants.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-echo.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_plugins_exec_method_head_if_not_exists_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_FALSE}
  }

  if ! mrcmd_plugins_exec_method_head SINGLE "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_pluginMethodExists_exec_plugin_head() {
  return
}

function mrcmd_plugins_exec_method_if_exists_test() {
  function mrcore_lib_func_exists() {
    ${RETURN_TRUE}
  }

  function mrcmd_pluginMethodExists_echo_SINGLE_plugin_head() {
    if [[ "${1:?}" == "pluginName" ]]; then
      ${RETURN_TRUE}
    fi

    ${RETURN_FALSE}
  }

  if ! mrcmd_plugins_exec_method_head SINGLE "pluginName" "pluginMethodExists" ; then
    ${EXIT_ERROR}
  fi
}
