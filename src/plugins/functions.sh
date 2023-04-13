
# shared vars, only for mrcmd_plugins_call_function
MRCMD_CURRENT_PLUGINS_DIR=""
MRCMD_CURRENT_PLUGIN_NAME=""

function mrcmd_plugins_call_function() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local scriptPath=${1:?}
  shift

  local pluginsDir
  local scriptFunc="mrcmd_func_${scriptPath//[\/-]/_}"
  local currentPluginName=${scriptPath%%/*}
  local currentPluginsDir
  local i=0

  for pluginsDir in "${MRCMD_PLUGINS_DIR_ARRAY[@]}"
  do
    currentPluginsDir="${pluginsDir}"
    local TMP_PATH="${pluginsDir}/${scriptPath}.sh"

    if [ -f "${TMP_PATH}" ]; then
      scriptPath=${TMP_PATH}
      break
    fi

    if mrcmd_main_is_project_dir_index ${i} ; then # if end of MRCMD_PLUGINS_DIR_ARRAY
      mrcore_echo_error "File ${TMP_PATH} for function ${scriptFunc} not found"
      mrcore_echo_sample "Source command: mrcmd_plugins_call_function ${scriptPath}"
      ${EXIT_ERROR}
    fi

    mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File ${TMP_PATH} for function ${scriptFunc} not found [skipped]"

    i=$((i + 1))
  done

  if ! mrcore_lib_function_exists "${scriptFunc}" ; then
    mrcore_import "${scriptPath}"

    if ! mrcore_lib_function_exists "${scriptFunc}" ; then
      mrcore_echo_error "Function ${scriptFunc} not found in ${scriptPath}"
      ${EXIT_ERROR}
    fi

    mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded function ${scriptFunc}() from ${scriptPath}"
  fi

  mrcore_debug_echo_call_function "${scriptFunc}" "$@"

  # store current context
  local oldCurrentPluginName=${MRCMD_CURRENT_PLUGIN_NAME}
  local oldCurrentPluginsDir=${MRCMD_CURRENT_PLUGINS_DIR}

  MRCMD_CURRENT_PLUGIN_NAME=${currentPluginName}
  MRCMD_CURRENT_PLUGINS_DIR=${currentPluginsDir}

  ${scriptFunc} "$@"

  # restore current context
  MRCMD_CURRENT_PLUGIN_NAME=${oldCurrentPluginName}
  MRCMD_CURRENT_PLUGINS_DIR=${oldCurrentPluginsDir}
}