
function mrcmd_config_exec() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_plugins_exec_current_state
}
