
function mrcmd_export_config_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  local name
  local length

  name="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "NAME")"
  varsCount="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "VARS" array_count)"

  if [[ ${varsCount} -gt 0 ]]; then
    echo -e "\n## ${name}:" >>"${APPX_DIR}/.env.exported"
    echo -e "${CC_YELLOW}${name}${CC_END} (${CC_GREEN}${pluginName}${CC_END}) exported: ${varsCount} vars"
  else
    echo -e "${CC_YELLOW}${pluginName} vars not found${CC_END}"
  fi
}

function mrcmd_export_config_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  mrcmd_export_config_echo_GROUP_plugin_head "${pluginName}"
}
