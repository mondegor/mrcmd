
function mrcmd_plugins_exec_state() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  local appxEnvFiles="${CC_RED}not specified${CC_END}"
  local mrcmdPluginsDir="${CC_RED}not specified${CC_END}"
  local appxPluginsDir="${CC_RED}not specified${CC_END}"

  if [[ ${#MRCORE_DOTENV_ARRAY[@]} -gt 0 ]]; then
    appxEnvFiles="${CC_BLUE}$(mrcmd_lib_implode ", " MRCORE_DOTENV_ARRAY[@])${CC_END}"
  fi

  if [ -n "${MRCMD_PLUGINS_DIR}" ]; then
    mrcmdPluginsDir="${CC_BLUE}${MRCMD_PLUGINS_DIR}${CC_END}"
  fi

  if [ -n "${APPX_PLUGINS_DIR}" ]; then
    appxPluginsDir="${CC_BLUE}${APPX_PLUGINS_DIR}${CC_END}"
  fi

  echo -e "${CC_YELLOW}${MRCMD_INFO_CAPTION} path${CC_END}: ${CC_BLUE}${MRCMD_DIR}${CC_END}"
  echo -e "${CC_YELLOW}Project path${CC_END}: ${CC_BLUE}${APPX_DIR_REAL}${CC_END}"
  echo -e "${CC_YELLOW}Env files${CC_END}: ${appxEnvFiles}"
  echo -e "${CC_YELLOW}Shared plugins path${CC_END}: ${mrcmdPluginsDir}"
  echo -e "${CC_YELLOW}Project plugins path${CC_END}: ${appxPluginsDir}"

  if [[ ${#MRCORE_DOTENV_ARRAY[@]} -eq 0 ]]; then
    mrcore_echo_sample "Run '${MRCMD_INFO_NAME} init' to initialize a new ${MRCMD_INFO_CAPTION} project"
    return
  fi

  echo ""

  mrcmd_plugins_exec_state_available_plugins
  mrcmd_plugins_exec_state_shared_plugins
  mrcmd_plugins_exec_state_project_plugins

  if mrcmd_plugins_lib_is_enabled pm ; then
    mrcore_echo_sample "Run '${MRCMD_INFO_NAME} pm all' for more details about available plugins"
  fi
}

# private
function mrcmd_plugins_exec_state_available_plugins() {
  echo -en "${CC_YELLOW}Available plugins${CC_END}: ${#MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  echo -en ", ${CC_GREEN}Loaded${CC_END}: ${#MRCMD_PLUGINS_LOADED_ARRAY[@]}"

  if [[ ${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]} -gt 0 ]]; then
    echo -en ", ${CC_RED}Required${CC_END}: ${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]}"
    echo -en ", ${CC_RED}Rejected${CC_END}: ${#MRCMD_PLUGINS_LOADING_ARRAY[@]}"
  fi

  echo ""
  #echo ""

  if [[ ${#MRCMD_PLUGINS_LOADED_ARRAY[@]} -gt 0 ]]; then
    echo -e "${CC_GREEN}Loaded plugins${CC_END}:"
    mrcore_echo_ok "$(mrcmd_lib_implode "," MRCMD_PLUGINS_LOADED_ARRAY[@])" "  "
  fi

  if [[ ${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]} -gt 0 ]]; then
    echo -e "${CC_RED}Required plugins${CC_END}:"
    mrcore_echo_error "$(mrcmd_lib_implode "," MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@])" "  "

    echo -e "${CC_RED}Rejected plugins${CC_END}:"
    mrcore_echo_error "$(mrcmd_lib_implode "," MRCMD_PLUGINS_LOADING_ARRAY[@])" "  "
  fi
}

# private
function mrcmd_plugins_exec_state_shared_plugins() {
  if [ -z "${MRCMD_PLUGINS_DIR}" ]; then
    echo -e "${CC_YELLOW}Two ways to include shared plugins:${CC_END}"
    echo -e "  - Set 'MRCMD_PLUGINS_DIR={DIR_NAME}' in ${CC_BLUE}$(mrcore_dotenv_get_first)${CC_END}"
    echo -e "  - Run '${MRCMD_INFO_NAME} --shared-plugins-dir {DIR_NAME}'"
    echo ""
    return
  fi

  local pluginsAvailable
  pluginsAvailable=$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_SHARED} MRCMD_PLUGINS_LOADED_ARRAY[@])

  if [ -z "${pluginsAvailable}" ]; then
    if [ -z "$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_SHARED})" ]; then
      mrcore_echo_error "No shared plugins found in ${MRCMD_PLUGINS_DIR}"
    fi
  else
    echo -e "${CC_YELLOW}Available shared plugins:${CC_END}"
    mrcore_echo_sample "${pluginsAvailable}" "  "

    echo -e "For example, to enable \"global\" and \"pm\" shared plugins, you "
    echo -e "need to add the following variable to ${CC_BLUE}${MRCORE_DOTENV_DEFAULT}${CC_END}:"
    mrcore_echo_sample "MRCMD_SHARED_PLUGINS_ENABLED=\"global,pm\"" "  "
  fi

  echo -e "${CC_YELLOW}Current value of${CC_END} MRCMD_SHARED_PLUGINS_ENABLED:"

  if [ -n "${MRCMD_SHARED_PLUGINS_ENABLED-}" ]; then
    mrcore_echo_warning "${MRCMD_SHARED_PLUGINS_ENABLED}" "  "
  else
    mrcore_echo_error "MRCMD_SHARED_PLUGINS_ENABLED is not exists in $(mrcore_dotenv_get_first)" "  "
  fi
}

# private
function mrcmd_plugins_exec_state_project_plugins() {
  if [ -z "${APPX_PLUGINS_DIR}" ]; then
    echo -e "${CC_YELLOW}Two ways to include project plugins:${CC_END}"
    echo -e "  - Set 'APPX_PLUGINS_DIR={DIR_NAME}' in ${CC_BLUE}$(mrcore_dotenv_get_first)${CC_END}"
    echo -e "  - Run '${MRCMD_INFO_NAME} --plugins-dir {DIR_NAME}'"
    echo ""
    return
  fi

  echo -e "${CC_YELLOW}Enabled project plugins${CC_END}:"

  local pluginsAvailable
  pluginsAvailable=$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_PROJECT})

  if [ -z "${pluginsAvailable}" ]; then
    mrcore_echo_error "No project plugins found in ${APPX_PLUGINS_DIR}" "  "
  else
    mrcore_echo_ok "${pluginsAvailable}" "  "
  fi
}
