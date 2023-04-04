#!/bin/bash

mrcmd_plugins_cmd_method_exec() {
  local COMMAND=${1:?}

  case ${COMMAND} in

    plugin_create)
      local PLUGIN_NAME=${2}

      if [ -z "${PLUGIN_NAME}" ]; then
        mrcmd_echo_message_error "Plugin name is required"
        exit 1
      fi

      if [ -z "${APPX_PLUGINS_DIR}" ]; then
        mrcmd_echo_message_error "Project plugins dir is not specified"
        exit 1
      fi

      export MRVAR_PLUGIN_NAME=${PLUGIN_NAME}

      envsubst "\${MRVAR_PLUGIN_NAME}" < "${MRCMD_DIR}/templates/plugin.sh.template" > "${APPX_PLUGINS_DIR}/${PLUGIN_NAME}.sh"

      unset MRVAR_PLUGIN_NAME
      ;;

    *)
      # shellcheck disable=SC2034
      MRCMD_PLUGINS_METHOD_IS_EXECUTED=false
      ;;

  esac
}

mrcmd_plugins_cmd_method_help() {
  local NOT_USED
}
