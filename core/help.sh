#!/bin/bash

mrcmd_help_exec() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_help_head

  echo -e "${CC_YELLOW}Usage:${CC_END}"
  echo -e "  command [arguments]"
  echo ""
  echo -e "${CC_YELLOW}Available commands:${CC_END}"

  mrcmd_plugins_exec_method help false
  mrcmd_scripts_help_exec
}

mrcmd_help_head() {
  mrcmd_check_var_required MRCMD_VERSION

  echo ""
  echo "███╗   ███╗██████╗  █████╗ ███╗   ███╗██████╗ "
  echo "████╗ ████║██╔══██╗██╔══██╗████╗ ████║██╔══██╗"
  echo "██╔████╔██║██████╔╝██║  ╚═╝██╔████╔██║██║  ██║"
  echo "██║╚██╔╝██║██╔══██╗██║  ██╗██║╚██╔╝██║██║  ██║"
  echo "██║ ╚═╝ ██║██║  ██║╚█████╔╝██║ ╚═╝ ██║██████╔╝"
  echo "╚═╝     ╚═╝╚═╝  ╚═╝ ╚════╝ ╚═╝     ╚═╝╚═════╝ "
  echo ""
  echo -e "${CC_GREEN}Mrcmd${CC_END} version ${CC_YELLOW}${MRCMD_VERSION}${CC_END}"
  echo ""
}
