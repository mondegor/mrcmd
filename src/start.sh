
function mrcmd_start_echo_GROUP_plugin_head() {
  local pluginName="${1:?}"
  mrcmd_plugins_exec_method GROUP "${pluginName}" config
}

function mrcmd_start_echo_SINGLE_plugin_head() {
  local pluginName="${1:?}"
  mrcmd_plugins_exec_method SINGLE "${pluginName}" config
}