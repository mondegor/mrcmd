
mrcore_import "${MRCMD_DIR}/src/plugins/methods.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-echo-call-function.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_plugins_exec_single_method_if_empty_test() {
  function mrcore_echo_sample {
    return
  }

  if ! mrcmd_plugins_exec_SINGLE_method "pluginName" "" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_plugins_exec_method_if_system_test() {
  function mrcore_lib_in_array() {
    ${RETURN_TRUE}
  }

  function mrcmd_plugins_exec_method() {
    if [[ "${1:?}" == "pluginName" ]] && [[ "${2:?}" == "pluginMethod" ]]; then
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
    if [[ "${1:?}" != "pluginName" ]] || [[ "${2:?}" != "exec" ]]; then
      ${RETURN_FALSE}
    fi
  }

  ################################################################################

  if ! mrcmd_plugins_exec_SINGLE_method "pluginName" "pluginMethod" ; then
    ${EXIT_ERROR}
  fi
}
