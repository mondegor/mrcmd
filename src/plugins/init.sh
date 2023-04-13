
export MRCMD_SHARED_PLUGINS_ENABLED

function mrcmd_plugins_init() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  imrcmd_plugins_enabled_array_init "${MRCMD_SHARED_PLUGINS_ENABLED-}"
  mrcmd_plugins_load
  mrcmd_plugins_exec_group_methods "init"
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
      mrcore_echo_warning "The ${pluginName} plugin already registered in MRCMD_SHARED_PLUGINS_ENABLED [skipped]"
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

      if mrcore_lib_in_array "${pluginName}" MRCMD_PLUGINS_LOADED_ARRAY[@] ; then
        mrcore_echo_error "Conflict: the ${pluginName} plugin in ${pluginDir} already registered in shared dir [skipped]"
        continue
      fi

      if mrcmd_main_is_project_dir_index ${i} ||
         mrcore_lib_in_array "${pluginName}" MRCMD_SHARED_PLUGINS_ENABLED_ARRAY[@] ; then
        mrcore_import "${pluginPath}"

        mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Loaded ${pluginName} from ${pluginPath}"

        MRCMD_PLUGINS_LOADED_ARRAY+=("${pluginName}")
      else
        mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Plugin: ${pluginPath} [skipped]"
      fi

      MRCMD_PLUGINS_AVAILABLE_ARRAY+=("${pluginName}")
      MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY+=("${i}")
    done

    i=$((i + 1))
  done
}
