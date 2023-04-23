
# using example: value=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}" "${pluginMethod}")
function mrcmd_plugins_lib_get_plugin_method_name() {
  local pluginName="${1:?}"
  local pluginMethod="${2:-}"

  echo "mrcmd_plugins_${pluginName//[\/-]/_}_method_${pluginMethod//-/_}"
}

# using example: value=$(mrcmd_plugins_lib_get_plugins_available)
function mrcmd_plugins_lib_get_plugins_available() {
  local filterDirIndex=${1:?}
  local pluginName
  local pluginsAvailable=""
  local dirIndex=0
  local i=0

  for pluginName in "${MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  do
    dirIndex=${MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY[${i}]}
    i=$((i + 1))

    if [[ ${dirIndex} -eq ${filterDirIndex} ]]; then
      pluginsAvailable="${pluginsAvailable},${pluginName}"
    fi
  done

  echo "${pluginsAvailable:1}"
}

# using example: if mrcmd_plugins_lib_is_enabled "${pluginName}" ; then
function mrcmd_plugins_lib_is_enabled() {
  local pluginName="${1:?}"
  local currentItem

  for currentItem in "${MRCMD_SHARED_PLUGINS_ENABLED_ARRAY[@]}"
  do
    if [[ "${currentItem}" == "${pluginName}" ]]; then
      ${RETURN_TRUE}
    fi
  done

  ${RETURN_FALSE}
}

# using example: $(mrcmd_plugins_lib_get_plugin_var_value "${pluginName}" "${varName}")
function mrcmd_plugins_lib_get_plugin_var_value() {
  local pluginName="${1:?}"
  local varName="${2:?}"
  pluginName=${pluginName//-/_}
  eval local varValue="\"\${${pluginName^^}_${varName}}\""

  echo "${varValue}"
}
