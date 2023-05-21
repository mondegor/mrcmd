
function mrcmd_plugins_depends_plugin_load_depends() {
  local pluginName="${1:?}"
  fullPluginMethod=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}" "depends")

  MRCMD_PLUGIN_DEPENDS_ARRAY=()

  if mrcore_lib_func_exists "${fullPluginMethod}" ; then
    if ! ${fullPluginMethod} ; then
      mrcore_echo_error "${fullPluginMethod}() crashed"
    fi
  else
    mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_BLUE}" "Plugin method: ${fullPluginMethod}() [skipped]"
  fi
}

function mrcmd_plugins_depends_plugin_clean_depends() {
  local item
  local tmp=()
  local isChanged=false

  for item in "${MRCMD_PLUGIN_DEPENDS_ARRAY[@]}"; do
    if mrcore_lib_in_array "${item}" MRCMD_PLUGINS_LOADED_ARRAY[@] ; then
      isChanged=true
    else
      tmp+=("${item}")
    fi
  done

  if [[ "${isChanged}" == true ]]; then
    MRCMD_PLUGIN_DEPENDS_ARRAY=("${tmp[@]}")
  fi
}

function mrcmd_plugins_depends_merge() {
  local array=("${!1-}")

  if [ "${#array[@]}" -eq 0 ]; then
    return
  fi

  local item

  for item in "${array[@]}"; do
    if ! mrcore_lib_in_array "${item}" MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@] ; then
      MRCMD_PLUGINS_DEPENDS_ALL_ARRAY+=("${item}")
    fi
  done
}

function mrcmd_plugins_depends_remove_plugin() {
  local pluginName="${1:?}"
  local item
  local tmp=()
  local isChanged=false

  for item in "${MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]}"; do
    if [[ "${item}" == "${pluginName}" ]]; then
      isChanged=true
    else
      tmp+=("${item}")
    fi
  done

  if [[ "${isChanged}" == true ]]; then
    MRCMD_PLUGINS_DEPENDS_ALL_ARRAY=("${tmp[@]}")
  fi
}