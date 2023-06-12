
function mrcmd_init_exec() {
  if [[ ${#MRCORE_DOTENV_ARRAY[@]} -gt 0 ]]; then
    mrcore_echo_error "${MRCMD_INFO_CAPTION} project is already initialized"
    mrcmd_init_exec_help
    return
  fi

  if [ -z "${MRCMD_PLUGINS_DIR}" ]; then
    mrcore_echo_error "Shared plugins dir is empty"
    mrcore_echo_sample "Run '${MRCMD_INFO_NAME} --shared-plugins-dir {DIR_NAME} init'"
    return
  fi

  local mrcmdPluginsPrefix

  if [[ "${MRCMD_PLUGINS_DIR}" == "${MRCMD_SHARED_PLUGINS_DIR_DEFAULT}" ]]; then
    mrcmdPluginsPrefix="# "
  fi

  local pluginsAvailable
  pluginsAvailable=$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_SHARED})

  if [ -z "${pluginsAvailable}" ]; then
    mrcore_echo_error "Shared plugins not found in '${MRCMD_PLUGINS_DIR}'"
    return
  fi

  cat >> "${MRCORE_DOTENV_DEFAULT}" <<EOL
## System readonly vars: \${APPX_DIR}, \${CMD_SEPARATOR}
## System vars:
${mrcmdPluginsPrefix}MRCMD_PLUGINS_DIR=${MRCMD_PLUGINS_DIR}
# APPX_PLUGINS_DIR=${APPX_PLUGINS_DIR}
MRCMD_SHARED_PLUGINS_ENABLED=docker,docker-compose,global,pm
# Available shared plugins: ${pluginsAvailable}
EOL

  mrcore_echo_ok "${MRCMD_INFO_CAPTION} project has been initialized, file '${MRCORE_DOTENV_DEFAULT}' created"
  mrcmd_init_exec_help
}

function mrcmd_init_exec_help() {
  echo -e "${CC_YELLOW}Setting after init:${CC_END}"
  echo -e "  1. Open and edit ${CC_BLUE}${MRCORE_DOTENV_DEFAULT}${CC_END};"
  echo -e "    1.1. Change var MRCMD_SHARED_PLUGINS_ENABLED in ${CC_BLUE}${MRCORE_DOTENV_DEFAULT}${CC_END};"
  echo -e "         (See available shared plugins)"
  echo -e "    1.2. Uncomment the APPX_PLUGINS_DIR variable and set the path"
  echo -e "         to the project plugins in it; [OPTIONAL]"
  echo -e "  3. Run '${MRCMD_INFO_NAME} state' for check enabled plugins;"
  echo -e "  4. Run '${MRCMD_INFO_NAME} export-config' to generate enabled plugins config;"
  echo -e "  5. Copy the necessary variables from generated ${CC_BLUE}${MRCORE_DOTENV_EXPORTED}${CC_END} to ${CC_BLUE}${MRCORE_DOTENV_DEFAULT}${CC_END};"
}
