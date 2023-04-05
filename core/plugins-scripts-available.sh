#!/bin/bash

mrcmd_scripts_help_available_exec() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}" "$@"

  mrcmd_scripts_load
  mrcmd_help_head
  mrcmd_scripts_available_list
}

# private
mrcmd_scripts_available_list() {
  mrcmd_check_env_var_required MRCMD_SCRIPTS_LOADED_ARRAY
  mrcmd_check_env_var_required MRCMD_SCRIPTS_LOADED_DIRS_ARRAY

  echo -e "${CC_YELLOW}Available core scripts:${CC_END}"
  echo ""

  local SCRIPT_NAME
  local DIR_INDEX
  local DIR_INDEX_LAST=0
  local PLUGINS_DIR
  local II=0

  for SCRIPT_NAME in "${MRCMD_SCRIPTS_LOADED_ARRAY[@]}"
  do
    DIR_INDEX=${MRCMD_SCRIPTS_LOADED_DIRS_ARRAY[${II}]}
    PLUGINS_DIR=${MRCMD_PLUGINS_DIR_ARRAY[${DIR_INDEX}]}

    if [[ ${DIR_INDEX} -ne ${DIR_INDEX_LAST} ]]; then
      DIR_INDEX_LAST=${DIR_INDEX}

      echo -e "${CC_YELLOW}Available project scripts:${CC_END}"
      echo ""
    fi

    mrcmd_scripts_available_echo_function "${SCRIPT_NAME}" "${PLUGINS_DIR}/${SCRIPT_NAME}.sh"

    II=$((II + 1))
  done
}

# private
mrcmd_scripts_available_echo_function() {
  local SCRIPT_NAME=${1:?}
  local SCRIPT_PATH=${2:?}

  SCRIPT_FUNCTION="mrcmd_scripts_${SCRIPT_NAME//[\/-]/_}"
  IS_FUNC_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

  echo -e "  ${CC_GREEN}${SCRIPT_NAME}${CC_END} in ${CC_BLUE}${SCRIPT_PATH}${CC_END}"

  if [[ "${IS_FUNC_EXISTS}" == true ]]; then
    echo -e "    ${SCRIPT_FUNCTION}() [${CC_LIGHT_GREEN}enabled${CC_END}]"
  else
    echo -e "    ${CC_GRAY}${SCRIPT_FUNCTION}${CC_END}() [${CC_RED}not found${CC_END}]"
  fi

  echo ""
}

mrcmd_scripts_help_exec() {
  mrcmd_debug_echo_call_function "${FUNCNAME[0]}" "$@"
  mrcmd_scripts_load

  local SCRIPT_NAME
  local DIR_INDEX
  local DIR_INDEX_LAST=0
  local II=0

  echo -e "${CC_YELLOW}Call core script functions in code:${CC_END}"

  for SCRIPT_NAME in "${MRCMD_SCRIPTS_LOADED_ARRAY[@]}"
  do
    DIR_INDEX=${MRCMD_SCRIPTS_LOADED_DIRS_ARRAY[${II}]}

    if [[ ${DIR_INDEX} -ne ${DIR_INDEX_LAST} ]]; then
      DIR_INDEX_LAST=${DIR_INDEX}

      echo ""
      echo -e "${CC_YELLOW}Call project script functions in code:${CC_END}"
    fi

    mrcmd_scripts_help_echo_function "${SCRIPT_NAME}"

    II=$((II + 1))
  done

  echo ""
}

# private
mrcmd_scripts_help_echo_function() {
  local SCRIPT_NAME=${1:?}

  SCRIPT_FUNCTION="mrcmd_scripts_${SCRIPT_NAME//[\/-]/_}"
  IS_FUNC_EXISTS="$(mrcmd_function_exists "${SCRIPT_FUNCTION}")"

  if [[ "${IS_FUNC_EXISTS}" == true ]]; then
    echo -e "  ${CC_GREEN}mrcmd_scripts_call_function${CC_END} ${SCRIPT_NAME} [arguments]"
  fi
}
