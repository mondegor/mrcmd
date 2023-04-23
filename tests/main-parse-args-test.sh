
mrcore_import "${MRCMD_DIR}/src/main.sh"

function mrcmd_main_parse_args_debug_level_valid1_test() {
  MRCORE_DEBUG_LEVEL=0
  DEBUG_LEVEL_3=3

  function mrcore_debug_level_validate {
    ${RETURN_TRUE}
  }

  if mrcmd_main_parse_args --debug ${DEBUG_LEVEL_3} ; then
    if [[ ${MRCORE_DEBUG_LEVEL} -eq ${DEBUG_LEVEL_3} ]] ; then
      ${RETURN_TRUE}
    fi
  fi

  ${EXIT_ERROR}
}

################################################################################

function mrcmd_main_parse_args_debug_level_error1_test() {
  function mrcore_debug_level_validate {
    ${RETURN_FALSE}
  }

  if [[ ! "$(mrcmd_main_parse_args --debug "bad_value" 2>&1)" =~ "debug" ]] ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_main_parse_args_no_color_valid1_test() {
  MRCORE_USE_COLOR=true

  if mrcmd_main_parse_args --no-color ; then
    if [[ "${MRCORE_USE_COLOR}" == false ]] ; then
      ${RETURN_TRUE}
    fi
  fi

  ${EXIT_ERROR}
}

################################################################################

function mrcmd_main_parse_args_verbose_valid1_test() {
  MRCORE_VERBOSE=false

  if mrcmd_main_parse_args --verbose ; then
    if [[ "${MRCORE_VERBOSE}" == true ]] ; then
      ${RETURN_TRUE}
    fi
  fi

  ${EXIT_ERROR}
}

function mrcmd_main_parse_args_version_valid1_test() {
  result=$(mrcmd_main_parse_args --version 2>&1)

  if [[ ! "${result}" =~ "version" ]] ; then
    ${EXIT_ERROR}
  fi
}

function mrcmd_main_parse_args_project_plugins_dir_valid1_test() {
  if ! mrcmd_main_parse_args --plugins-dir "dirname" ; then
    ${EXIT_ERROR}
  fi
}

function mrcmd_main_parse_args_project_plugins_dir_error1_test() {
  if [[ ! "$(mrcmd_main_parse_args --plugins-dir 2>&1)" =~ "plugins-dir" ]] ; then
    ${EXIT_ERROR}
  fi
}

function mrcmd_main_parse_args_env_file_valid1_test() {
  if ! mrcmd_main_parse_args --env-file "file-name" ; then
    ${EXIT_ERROR}
  fi
}

function mrcmd_main_parse_args_env_file_error1_test() {
  if [[ ! "$(mrcmd_main_parse_args --env-file 2>&1)" =~ "env-file" ]] ; then
    ${EXIT_ERROR}
  fi
}

