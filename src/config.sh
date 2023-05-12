
function mrcmd_config_GROUP_exec() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_plugins_exec_GROUP_methods config
}

function mrcmd_config_echo_GROUP_plugin_head() {
  echo ""
  mrcmd_plugins_default_echo_GROUP_plugin_head "$@"
}

function mrcmd_config_SINGLE_exec() {
  local pluginName="${1:?}"
  mrcore_debug_echo_call_function "${FUNCNAME[0]}(${pluginName})"

  mrcmd_plugins_exec_SINGLE_method "${pluginName}" config
}

function mrcmd_config_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  echo -e "${CC_YELLOW}$(mrcmd_plugins_lib_get_plugin_var "${pluginName}" "NAME") plugin config:${CC_END}"
}
