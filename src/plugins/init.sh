
MRCMD_SHARED_PLUGINS_ENABLED=""

function mrcmd_plugins_init() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  imrcmd_plugins_enabled_array_init "${MRCMD_SHARED_PLUGINS_ENABLED-}"
  mrcmd_plugins_load
}

# private
function imrcmd_plugins_enabled_array_init() {
  MRCMD_SHARED_PLUGINS_ENABLED_ARRAY=()

  if [[ -z "${MRCMD_SHARED_PLUGINS_ENABLED-}" ]]; then
    return;
  fi

  local separator=","
  local tmpArray
  readarray -td${separator} tmpArray <<<"${MRCMD_SHARED_PLUGINS_ENABLED}${separator}"; unset 'tmpArray[-1]';

  local pluginName

  for pluginName in "${tmpArray[@]}"
  do
    if mrcore_lib_in_array "${pluginName}" MRCMD_SHARED_PLUGINS_ENABLED_ARRAY[@] ; then
      mrcore_echo_warning "Plugin '${pluginName}' already registered in MRCMD_SHARED_PLUGINS_ENABLED [skipped]"
      continue
    fi

    MRCMD_SHARED_PLUGINS_ENABLED_ARRAY+=("${pluginName}")
  done
}

function mrcmd_plugins_load() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  local pluginsDir
  local pathLength
  local pluginDir
  local pluginName
  local pluginPath
  local i=0

  MRCMD_PLUGINS_AVAILABLE_ARRAY=()
  MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY=()
  MRCMD_PLUGINS_LOADED_ARRAY=()
  MRCMD_PLUGINS_LOADING_ARRAY=()
  MRCMD_PLUGINS_DEPENDS_ALL_ARRAY=()

  for pluginsDir in "${MRCMD_PLUGINS_DIR_ARRAY[@]}"
  do
    # if project plugins dir not included
    if [[ -z "${pluginsDir}" ]]; then
      continue
    fi

    for pluginDir in "${pluginsDir}"/*
    do
      if [ ! -d "${pluginDir}" ]; then
        mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "File ${pluginDir} ignored"
        continue
      fi

      pathLength=$((${#pluginsDir} + 1))
      pluginName="${pluginDir:${pathLength}}"
      pluginPath="${pluginDir}/${pluginName}.sh"

      if [ ! -f "${pluginPath}" ]; then
        mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Dir ${pluginDir} ignored"
        continue
      fi

      if mrcore_lib_in_array "${pluginName}" MRCMD_PLUGINS_LOADED_ARRAY[@] ||
         mrcore_lib_in_array "${pluginName}" MRCMD_PLUGINS_LOADING_ARRAY[@] ; then
        mrcore_echo_error "Conflict: plugin '${pluginName}' in ${pluginDir} already registered in shared dir [skipped]"
        continue
      fi

      if [[ ${MRCMD_PLUGINS_DIR_INDEX_PROJECT} -eq ${i} ]] ||
         mrcore_lib_in_array "${pluginName}" MRCMD_SHARED_PLUGINS_ENABLED_ARRAY[@] ; then

        mrcore_import "${pluginPath}"
        mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Imported '${pluginName}' from ${pluginPath}"

        mrcmd_plugins_load_if_depends_loaded "${pluginName}"
      else
        mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_RED}" "Plugin: ${pluginPath} [disabled]"
      fi

      MRCMD_PLUGINS_AVAILABLE_ARRAY+=("${pluginName}")
      MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY+=("${i}")
    done

    i=$((i + 1))
  done

  while :; do
    if [[ "${#MRCMD_PLUGINS_LOADING_ARRAY[@]}" -le 0 ]]; then
      return
    fi

    local pluginsLoadingArray=("${MRCMD_PLUGINS_LOADING_ARRAY[@]}")

    MRCMD_PLUGINS_LOADING_ARRAY=()
    MRCMD_PLUGINS_DEPENDS_ALL_ARRAY=()

    for pluginName in "${pluginsLoadingArray[@]}"
    do
      mrcmd_plugins_load_if_depends_loaded "${pluginName}"
    done

    if [[ "${#MRCMD_PLUGINS_LOADING_ARRAY[@]}" -ge ${#pluginsLoadingArray[@]} ]]; then
      return
    fi
  done

  mrcore_debug_echo_array MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]
  mrcore_debug_echo_array notLoadedPlugins[@]
  mrcore_debug_echo_array MRCMD_PLUGINS_LOADED_ARRAY[@]
}

# private
function mrcmd_plugins_load_if_depends_loaded() {
  local pluginName="${1:?}"

  mrcmd_plugins_depends_plugin_load_depends "${pluginName}"
  mrcmd_plugins_depends_plugin_clean_depends

  if [ "${#MRCMD_PLUGIN_DEPENDS_ARRAY[@]}" -eq 0 ]; then
    if mrcmd_plugins_load_if_initialized "${pluginName}" ; then
      mrcmd_plugins_depends_remove_plugin "${pluginName}"
    fi
  else
    MRCMD_PLUGINS_LOADING_ARRAY+=("${pluginName}")
    mrcmd_plugins_depends_merge MRCMD_PLUGIN_DEPENDS_ARRAY[@]
  fi
}

# private
function mrcmd_plugins_load_if_initialized() {
  local pluginName="${1:?}"
  local fullPluginMethod

  fullPluginMethod=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}" "init")

  if mrcore_lib_func_exists "${fullPluginMethod}" ; then
    mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}()"

    if "${fullPluginMethod}" ; then
      MRCMD_PLUGINS_LOADED_ARRAY+=("${pluginName}")
      ${RETURN_TRUE}
    fi

    mrcore_echo_error "Plugin method ${fullPluginMethod}() not initialized"
  else
    mrcore_echo_error "Plugin method ${fullPluginMethod}() not found"
  fi

  ${RETURN_FALSE}
}

# private
function mrcmd_plugins_load_init_methods() {
  local pluginName="${1:?}"
  local fullPluginMethod

  fullPluginMethod=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}" "init")

  if mrcore_lib_func_exists "${fullPluginMethod}" ; then
    mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_YELLOW}" "Exec method: ${fullPluginMethod}()"

    if ! "${fullPluginMethod}" ; then
      ${RETURN_FALSE}
    fi
  else
    mrcore_echo_error "Plugin method ${fullPluginMethod}() not found"
    ${RETURN_FALSE}
  fi
}
