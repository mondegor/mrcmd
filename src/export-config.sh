
function mrcmd_export_config_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  local pluginCaption

  pluginCaption="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "CAPTION")"
  varsCount="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "VARS" array_count)"

  if [[ ${varsCount} -gt 0 ]]; then
    if mrcmd_export_config_is_first_row ; then
      mrcore_echo_ok "Export enabled plugins config to '${MRCORE_DOTENV_EXPORTED}'"
    fi

    cat >> "${MRCORE_DOTENV_EXPORTED}" <<< "$(echo -e "\n## ${pluginCaption}:")"
    echo -e "${CC_YELLOW}${pluginCaption}${CC_END} (${CC_GREEN}${pluginName}${CC_END}) exported: ${varsCount} vars"
  else
    echo -e "${CC_YELLOW}${pluginName} vars not found${CC_END}"
  fi
}

function mrcmd_export_config_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  mrcmd_export_config_echo_GROUP_plugin_head "${pluginName}"
}

function mrcmd_export_config_is_first_row() {
  if [[ "${MRCMD_EXPORT_CONFIG_IS_FIRST_ROW_EXECUTED-}" == true ]]; then
    ${RETURN_FALSE}
  fi

  MRCMD_EXPORT_CONFIG_IS_FIRST_ROW_EXECUTED=true
  ${RETURN_TRUE}
}
