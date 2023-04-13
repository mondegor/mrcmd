
readonly MRCMD_AVAILABLE_PLUGIN_METHODS_ARRAY=("config" "export-config" "exec" "init" "install" "uninstall" "help")
readonly MRCMD_EXECUTABLE_PLUGIN_METHODS_ARRAY=("export-config" "install" "uninstall")

# необходимо пройтись по всем плагинам и в каждом вызывать
# указанную команду, если она в нём зарегистрированна
function mrcmd_plugins_exec_group_methods() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local pluginMethod=${1:?}
  # local IS_SHOW_HEAD=${2:?}
  shift

  local pluginName
  local fullPluginMethod
  local methodExecutedCount=0
  local totalPlugins=0
  local arguments="$@"

  for pluginName in "${MRCMD_PLUGINS_LOADED_ARRAY[@]}"
  do
    fullPluginMethod="mrcmd_plugins_${pluginName//[\/-]/_}_method_${pluginMethod}"
    totalPlugins=$((totalPlugins + 1))

    if ! mrcore_lib_function_exists "${fullPluginMethod}"; then
      mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Unimplemented method: ${fullPluginMethod}(${arguments}) [skipped]"
      continue
    fi

    mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}(${arguments})"

    #    if [[ "${IS_SHOW_HEAD}" == true ]]; then
    #      mrcore_echo_notice "Plugin ${pluginName}::${pluginMethod}()"
    #    fi

    # :WARNING: this condition catches method errors
    if "${fullPluginMethod}" "$@"; then
      methodExecutedCount=$((methodExecutedCount + 1))
    fi
  done

  if mrcore_lib_in_array "${pluginMethod}" MRCMD_EXECUTABLE_PLUGIN_METHODS_ARRAY[@]; then
    local TOTAL_BG_COLOR="${CC_BG_YELLOW}"

    if [[ ${methodExecutedCount} -eq ${totalPlugins} ]]; then
      TOTAL_BG_COLOR="${CC_BG_GREEN}"
    fi

    mrcore_echo_message "${TOTAL_BG_COLOR}" "Total plugins: ${totalPlugins}, Executed: ${methodExecutedCount}."
  fi
}

function mrcmd_plugins_exec_method() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  local executeMode=${1:?} # normal, force
  local pluginName=${2:?}
  shift; shift

  local pluginMethod=${1-}
  local pluginMethodProxy="exec"

  if [ -n "${pluginMethod}" ]; then
    if [[ "${executeMode}" == "force" ]] ||
      mrcore_lib_in_array "${pluginMethod}" MRCMD_EXECUTABLE_PLUGIN_METHODS_ARRAY[@]; then
      pluginMethodProxy=${pluginMethod}
      shift
    fi

    local fullPluginMethod="mrcmd_plugins_${pluginName//[\/-]/_}_method_${pluginMethodProxy}"

    if mrcore_lib_function_exists "${fullPluginMethod}"; then
      local arguments="$@"
      mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}(${arguments})"

      # :WARNING: this condition catches method errors
      if "${fullPluginMethod}" "$@" ; then
        return
      fi

      mrcore_echo_error "The ${pluginName} plugin does not have ${pluginMethod} method or it has crashed"
    else
      mrcore_echo_error "Method ${pluginMethod} for the ${pluginName} plugin not implemented"
    fi
  fi

  mrcore_echo_sample "Run '${MRCMD_INFO_NAME} help ${pluginName}' for usage"
}
