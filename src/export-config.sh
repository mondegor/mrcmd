
function mrcmd_export_config_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  local pluginCaption

  pluginCaption="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "CAPTION")"
  varsCount="$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "VARS" array_count)"

  if [[ ${varsCount} -gt 0 ]]; then
    if mrcmd_export_config_is_first_row ; then
      echo -e "# System global vars: \${MRCMD_DIR}, \${MRCMD_PLUGINS_DIR}, \${APPX_DIR}, \${APPX_PLUGINS_DIR}, \${CMD_SEPARATOR}" \
        >> "${APPX_DIR}/.env.exported"
    fi

    echo -e "\n## ${pluginCaption}:" >> "${APPX_DIR}/.env.exported"

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
