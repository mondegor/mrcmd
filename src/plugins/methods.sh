
readonly MRCMD_PLUGIN_METHODS_ARRAY=("config" "export-config" "install" "start" "stop" "uninstall" "help")
readonly MRCMD_PLUGIN_METHODS_SHOW_COMPLETED_ARRAY=("install" "start" "stop" "uninstall")

function mrcmd_plugins_default_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  echo -e "${CC_YELLOW}$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "CAPTION")${CC_END} (${CC_GREEN}${pluginName}${CC_END}):"
}

function mrcmd_plugins_default_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  echo -e "${CC_YELLOW}$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "CAPTION")${CC_END}:"
}

function mrcmd_plugins_exec_GROUP_methods() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local pluginMethod="${1:?}"
  shift

  local pluginName
  local methodExecutedCount=0
  local totalPlugins=0

  for pluginName in "${MRCMD_PLUGINS_LOADED_ARRAY[@]}"
  do
    totalPlugins=$((totalPlugins + 1))

    if mrcmd_plugins_exec_method GROUP "${pluginName}" "${pluginMethod}" "$@" ; then
      methodExecutedCount=$((methodExecutedCount + 1))
    fi
  done

  local totalBgColor="${CC_BG_YELLOW}"

  if [[ ${methodExecutedCount} -eq ${totalPlugins} ]]; then
    totalBgColor="${CC_BG_GREEN}"
  fi

  mrcore_echo_message "${totalBgColor}" "Total plugins: ${totalPlugins}, Executed: ${methodExecutedCount}."
}

function mrcmd_plugins_exec_SINGLE_method() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local pluginName="${1:?}"
  local pluginMethod="${2-}"
  local pluginMethodProxy="exec"
  shift

  if [ -n "${pluginMethod}" ]; then
    if mrcore_lib_in_array "${pluginMethod}" MRCMD_PLUGIN_METHODS_ARRAY[@]; then
      pluginMethodProxy=${pluginMethod}
      shift
    fi

    if mrcmd_plugins_exec_method SINGLE "${pluginName}" "${pluginMethodProxy}" "$@" ; then
      return
    else
      local errorCode="$?"

      case "${errorCode}" in

        "${ERROR_CODE_FALSE}")
          mrcore_echo_error "Method '${pluginMethod}' for plugin '${pluginName}' not implemented"
          ;;

        "${ERROR_CODE_UNKNOWN_COMMAND}")
          mrcore_echo_error "Command '${pluginMethod}' for plugin '${pluginName}' is unknown"
          ;;

      esac
    fi
  fi

  mrcore_echo_sample "Run '${MRCMD_INFO_NAME} ${pluginName} help' for usage"
}

function mrcmd_plugins_exec_method() {
  local execType="${1:?}"
  local pluginName="${2:?}"
  local pluginMethod="${3:?}"
  local fullPluginMethod
  shift; shift; shift

  fullPluginMethod=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}" "${pluginMethod}")
  local arguments="$@"

  if ! mrcore_lib_func_exists "${fullPluginMethod}" ; then
    mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Unimplemented method: ${fullPluginMethod}(${arguments}) [skipped]"
    ${RETURN_FALSE}
  fi

  mrcmd_plugins_exec_method_head "${execType}" "${pluginName}" "${pluginMethod}"

  mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}(${arguments})"

  if ${fullPluginMethod} "$@" ; then
    if mrcore_lib_in_array "${pluginMethod}" MRCMD_PLUGIN_METHODS_SHOW_COMPLETED_ARRAY[@] ; then
      mrcore_echo_notice "Command '${MRCMD_INFO_NAME} ${pluginName} ${pluginMethod}' completed"
    fi
    return
  else
    local errorCode="$?"

    if [[ "${errorCode}" -eq ${ERROR_CODE_UNKNOWN_COMMAND} ]] ; then
      ${RETURN_UNKNOWN_COMMAND}
    fi

    mrcore_echo_error "${fullPluginMethod}(${arguments}) crashed"
    ${RETURN_UNKNOWN_ERROR}
  fi
}

# private
function mrcmd_plugins_exec_method_head() {
  local execType="${1:?}"
  local pluginName="${2:?}"
  local pluginMethod="${3:?}"
  local fullPluginMethod="mrcmd_${pluginMethod//-/_}_echo_${execType}_plugin_head"

  if mrcore_lib_func_exists "${fullPluginMethod}" ; then
    mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}(${pluginName})"

    if ! ${fullPluginMethod} "${pluginName}" ; then
      mrcore_echo_error "${fullPluginMethod}() crashed"
    fi
  fi
}
