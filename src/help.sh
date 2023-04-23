
function mrcmd_help_GROUP_exec() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_help_exec_head

  #markup:"--|-|---------|-------|-------|---------------------------------------|"
  echo -e "${CC_GREEN}${MRCMD_INFO_CAPTION}${CC_END} is a tool for grouping and running shell tools, scripts, etc."
  echo ""
  echo -e "${CC_YELLOW}Usage:${CC_END}"
  echo -e "  [${CC_BLUE}options${CC_END}] ${CC_GREEN}COMMAND${CC_END} [arguments]"
  echo ""
  echo -e "${CC_YELLOW}Project options:${CC_END}"
  echo -e "  ${CC_BLUE}-d, --plugins-dir${CC_END} ${CC_CYAN}DIR${CC_END}    Set plugins dir for the project"
  echo -e "                           ${CC_CYAN}DIR${CC_END} is path"
  echo -e "  ${CC_BLUE}    --env-file${CC_END} ${CC_CYAN}PATH${CC_END}      Read in a file of environment variables"
  echo -e "                           [multiple supported]"
  echo -e "                           ${CC_CYAN}PATH${CC_END} is path"
  echo ""
  echo -e "${CC_YELLOW}Global options:${CC_END}"
  echo -e "  ${CC_BLUE}    --debug${CC_END} ${CC_CYAN}LEVEL${CC_END}        Enable debugging mode"
  echo -e "                           ${CC_CYAN}LEVEL${CC_END} is 1, 2, 3, or 4"
  echo -e "  ${CC_BLUE}-n, --no-color${CC_END}           Produce monochrome output"
  echo -e "  ${CC_BLUE}-V, --verbose${CC_END}            Explain what is being done"
  echo -e "  ${CC_BLUE}-v, --version${CC_END}            Display version information and exit"
  echo ""
  echo -e "${CC_YELLOW}Commands:${CC_END}"
  echo -e "  ${CC_GREEN}state${CC_END}       Current state of the project"
  echo ""
  echo -e "${CC_YELLOW}Group commands:${CC_END}"
  echo -e "  [${CC_BLUE}options${CC_END}] ${CC_GREEN}COMMAND${CC_END} [${CC_CYAN}PLUGIN${CC_END}]  ${CC_CYAN}PLUGIN${CC_END} is an enabled plugin"
  echo -e ""
  echo -e "  ${CC_GREEN}config${CC_END}          Display the project configuration"
  echo -e "  ${CC_GREEN}export-config${CC_END}   Create ${CC_BLUE}.env${CC_END} file for the project with all"
  echo -e "                  global variables of enabled plugins"
  echo -e "  ${CC_GREEN}install${CC_END}         Install the project"
  echo -e "  ${CC_GREEN}start${CC_END}           Start the project"
  echo -e "  ${CC_GREEN}stop${CC_END}            Stop the project"
  echo -e "  ${CC_GREEN}uninstall${CC_END}       Remove all project resources created during installation"
  echo -e "  ${CC_GREEN}help${CC_END}            Display this help text or help for the specified plugin"
  echo ""
  echo -e "${CC_YELLOW}Enabled plugins:${CC_END}"

  for pluginName in "${MRCMD_PLUGINS_LOADED_ARRAY[@]}"
  do
    mrcmd_help_echo_GROUP_plugin_head "${pluginName}"
  done

  mrcore_echo_sample "Run '${MRCMD_INFO_NAME} state' for more detailed information about the project"
}

function mrcmd_help_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  local length=25
  length=$((length - ${#pluginName}))

  echo -en "  ${CC_GREEN}${pluginName}${CC_END}"
  mrcore_lib_repeat_string " " ${length}
  echo -e "$(mrcmd_plugins_lib_get_plugin_var_value "${pluginName}" "NAME")"
}

function mrcmd_help_exec_head() {
  echo -e " ${CC_YELLOW} __  __   ___  ${CC_RED}  ___   __  __   ___  ${CC_END}"
  echo -e " ${CC_YELLOW}|  \/  | | _ \ ${CC_RED} / __| |  \/  | |   \ ${CC_END}"
  echo -e " ${CC_YELLOW}| |\/| | |   / ${CC_RED}| (__  | |\/| | | |) |${CC_END}"
  echo -e " ${CC_YELLOW}|_|  |_| |_|_\ ${CC_RED} \___| |_|  |_| |___/ ${CC_END}"
  echo -e "                           ${CC_YELLOW}ver. ${MRCMD_INFO_VERSION}${CC_END}"
  echo ""
}

function mrcmd_help_SINGLE_exec() {
  local pluginName="${1:?}"

  mrcore_debug_echo_call_function "${FUNCNAME[0]}(${pluginName})"
  mrcmd_plugins_exec_SINGLE_method "${pluginName}" help
}

function mrcmd_help_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  local pluginMethod
  local fullPluginMethodPrefix
  local pluginMethods=""

  echo -e "${CC_YELLOW}Usage:${CC_END}"
  echo -e "  ${MRCMD_INFO_NAME} ${CC_GREEN}${pluginName}${CC_END} [${CC_BLUE}options${CC_END}] COMMAND [arguments]"
  echo ""

  fullPluginMethodPrefix=$(mrcmd_plugins_lib_get_plugin_method_name "${pluginName}")

  for pluginMethod in "${MRCMD_SYSTEM_PLUGIN_METHODS_ARRAY[@]}"
  do
    if mrcore_lib_func_exists "${fullPluginMethodPrefix}${pluginMethod}" ; then
      pluginMethods="${pluginMethods}, ${pluginMethod}"
    fi
  done

  if [ -n "${pluginMethods}" ]; then
    echo -e "${CC_YELLOW}Based commands:${CC_END}"
    echo -e "  ${pluginMethods:2}"
    echo ""
  fi
}
