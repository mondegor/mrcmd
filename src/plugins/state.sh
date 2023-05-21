
function mrcmd_plugins_exec_state() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  local pluginsAvailable

  echo -e "${CC_YELLOW}${MRCMD_INFO_CAPTION} path${CC_END}: ${CC_BLUE}${MRCMD_DIR}${CC_END}"
  echo -e "${CC_YELLOW}Project path${CC_END}: ${CC_BLUE}${APPX_DIR_REAL}${CC_END}"
  echo -e "${CC_YELLOW}Shared plugins path${CC_END}: ${CC_BLUE}${MRCMD_PLUGINS_DIR}${CC_END}"
  echo -e "${CC_YELLOW}Project plugins path${CC_END}: ${CC_BLUE}${APPX_PLUGINS_DIR}${CC_END}"
  echo ""
  echo -en "${CC_YELLOW}Available plugins${CC_END}: ${#MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  echo -en ", ${CC_GREEN}Loaded${CC_END}: ${#MRCMD_PLUGINS_LOADED_ARRAY[@]}"

  if [[ "${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]}" -gt 0 ]]; then
    echo -en ", ${CC_RED}Required${CC_END}: ${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]}"
    echo -en ", ${CC_RED}Rejected${CC_END}: ${#MRCMD_PLUGINS_LOADING_ARRAY[@]}"
  fi

  echo ""
  echo ""

  if [[ "${#MRCMD_PLUGINS_LOADED_ARRAY[@]}" -gt 0 ]]; then
    echo -e "${CC_GREEN}Loaded plugins${CC_END}:"
    mrcore_echo_ok "$(mrcmd_lib_implode "," MRCMD_PLUGINS_LOADED_ARRAY[@])" "  "
  fi

  if [[ "${#MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@]}" -gt 0 ]]; then
    echo -e "${CC_RED}Required plugins${CC_END}:"
    mrcore_echo_error "$(mrcmd_lib_implode "," MRCMD_PLUGINS_DEPENDS_ALL_ARRAY[@])" "  "

    echo -e "${CC_RED}Rejected plugins${CC_END}:"
    mrcore_echo_error "$(mrcmd_lib_implode "," MRCMD_PLUGINS_LOADING_ARRAY[@])" "  "
  fi

  echo -e "${CC_YELLOW}Enabled shared plugins${CC_END} (${CC_YELLOW}value of${CC_END} MRCMD_SHARED_PLUGINS_ENABLED):"

  pluginsAvailable=$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_SHARED})

  if [ -z "${pluginsAvailable}" ]; then
    mrcore_echo_error "No shared plugins found in ${MRCMD_PLUGINS_DIR_ARRAY[${MRCMD_PLUGINS_DIR_INDEX_SHARED}]} directory" "  "
  elif [[ "${MRCMD_SHARED_PLUGINS_ENABLED-}" == "${pluginsAvailable}" ]]; then
    mrcore_echo_ok "${pluginsAvailable}" "  "
  else
    if [ -n "${MRCMD_SHARED_PLUGINS_ENABLED-}" ]; then
      mrcore_echo_warning "${MRCMD_SHARED_PLUGINS_ENABLED}" "  "
    else
      mrcore_echo_error "Var MRCMD_SHARED_PLUGINS_ENABLED is not set" "  "
    fi

    echo -e "${CC_YELLOW}Available shared plugins:${CC_END}"
    mrcore_echo_sample "${pluginsAvailable}" "  "

    echo -e "For example, to enable \"pm\" and \"global\" shared plugins, you "
    echo -e "need to add the following variable to ${CC_BLUE}${APPX_DIR}/.env${CC_END}:"
    mrcore_echo_sample "MRCMD_SHARED_PLUGINS_ENABLED=\"pm,global\"" "  "
  fi

  if [ -n "${APPX_PLUGINS_DIR}" ]; then
    echo -e "${CC_YELLOW}Enabled project plugins${CC_END}:"

    pluginsAvailable=$(mrcmd_plugins_lib_get_plugins_available ${MRCMD_PLUGINS_DIR_INDEX_PROJECT})

    if [ -z "${pluginsAvailable}" ]; then
      mrcore_echo_error "No project plugins found in ${APPX_PLUGINS_DIR} directory" "  "
    else
      mrcore_echo_ok "${pluginsAvailable}" "  "
    fi
  else
    mrcore_echo_sample "Run '${MRCMD_INFO_NAME} --plugins-dir ${APPX_DIR}/DIR' to include project plugins"
  fi

  if mrcmd_plugins_lib_is_enabled pm ; then
    mrcore_echo_sample "Run '${MRCMD_INFO_NAME} pm all' for more details about available plugins"
  fi
}
