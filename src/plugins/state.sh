
function mrcmd_plugins_exec_current_state() {
  mrcore_debug_echo_call_function "${FUNCNAME[0]}"

  mrcmd_help_exec_head

  local pluginsAvailable

  echo -e "Current status:"
  mrcore_echo_sample "Available plugins: ${#MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}, Enabled: ${#MRCMD_PLUGINS_LOADED_ARRAY[@]}." "  "

  echo -e "Current real project path:"
  mrcore_echo_sample "$(realpath "${APPX_DIR}")" "  "

  echo -e "Current value of ${CC_YELLOW}MRCMD_SHARED_PLUGINS_ENABLED${CC_END}:"

  pluginsAvailable=$(mrcmd_plugins_available_get_core_plugins_available)

  if [[ "${MRCMD_SHARED_PLUGINS_ENABLED-}" == "${pluginsAvailable}" ]]; then
    mrcore_echo_ok "${pluginsAvailable}" "  "
  else
    if [ -n "${MRCMD_SHARED_PLUGINS_ENABLED-}" ]; then
      mrcore_echo_warning "${MRCMD_SHARED_PLUGINS_ENABLED}" "  "
    else
      mrcore_echo_error "Var is not set" "  "
    fi

    echo -e "${CC_YELLOW}Available shared plugins:${CC_END}"
    mrcore_echo_sample "${pluginsAvailable}" "  "

    echo -e "For example, to enable all shared plugins, you need to add MRCMD_SHARED_PLUGINS_ENABLED to ${CC_BLUE}${APPX_DIR/}/.env${CC_END}:"
    mrcore_echo_sample "MRCMD_SHARED_PLUGINS_ENABLED=\"${pluginsAvailable}\"" "  "
    echo -e "And run ${MRCMD_INFO_NAME} with --env-file:"
    mrcore_echo_sample "${MRCMD_INFO_NAME} --env-file .env" "  "
  fi
}

# private
# using example: value=$(mrcmd_plugins_available_get_core_plugins_available)
function mrcmd_plugins_available_get_core_plugins_available() {
  local pluginName
  local pluginsAvailable=""
  local dirIndex=0
  local i=0

  for pluginName in "${MRCMD_PLUGINS_AVAILABLE_ARRAY[@]}"
  do
    dirIndex=${MRCMD_PLUGINS_AVAILABLE_DIRS_ARRAY[${i}]}
    i=$((i + 1))

    if ! mrcmd_main_is_shared_dir_index ${dirIndex} ; then
      continue
    fi

    pluginsAvailable="${pluginsAvailable},${pluginName}"
  done

  echo "${pluginsAvailable:1}"
}
