
function mrcmd_help_exec() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_help_exec_head

  echo -e "${CC_GREEN}${MRCMD_INFO_CAPTION}${CC_END} is a tool for grouping and running shell tools, scripts, etc."
  echo ""
  echo -e "${CC_YELLOW}Usage:${CC_END}"
  echo -e "  [${CC_BLUE}options${CC_END}] <${CC_GREEN}command${CC_END}> [arguments]"
  echo ""
  echo -e "${CC_YELLOW}Project options:${CC_END}"
  echo -e "  ${CC_BLUE}-d | --plugins-dir${CC_END}  Set plugins dir for the project"
  echo -e "  ${CC_BLUE}--env-file${CC_END}          Read in a file of environment variables [multiple supported]"
  echo ""
  echo -e "${CC_YELLOW}Miscellaneous:${CC_END}"
  echo -e "  ${CC_BLUE}--debug${CC_END} <level>     Enable debugging mode, level: 1-4"
  echo -e "  ${CC_BLUE}-n | --no-color${CC_END}     Produce monochrome output"
  echo -e "  ${CC_BLUE}-V | --verbose${CC_END}      Explain what is being done"
  echo -e "  ${CC_BLUE}-v | --version${CC_END}      display version information and exit"
  echo ""
  echo -e "${CC_YELLOW}Available group commands:${CC_END}"
  echo -e "  ${CC_GREEN}config${CC_END} <plugin=all>  Display the configuration of all enabled plugins or the specific one"
  echo -e "  ${CC_GREEN}export-config${CC_END}          Create a ${CC_BLUE}.env${CC_END} file for the project with all plugin settings"
  echo -e "  ${CC_GREEN}install${CC_END}              Install the project using all enabled plugins"
  echo -e "  ${CC_GREEN}uninstall${CC_END}            Remove all project resources created during installation"
  echo -e "  ${CC_GREEN}help${CC_END} <plugin=all>    Display this help text or help for the specified plugin"
  echo ""
}

function mrcmd_help_exec_head() {
  echo -e " ${CC_YELLOW} __  __   ___  ${CC_RED}  ___   __  __   ___  ${CC_END}"
  echo -e " ${CC_YELLOW}|  \/  | | _ \ ${CC_RED} / __| |  \/  | |   \ ${CC_END}"
  echo -e " ${CC_YELLOW}| |\/| | |   / ${CC_RED}| (__  | |\/| | | |) |${CC_END}"
  echo -e " ${CC_YELLOW}|_|  |_| |_|_\ ${CC_RED} \___| |_|  |_| |___/ ${CC_END}"
  echo -e "                           ${CC_YELLOW}ver. ${MRCMD_INFO_VERSION}${CC_END}"
  echo ""
}
