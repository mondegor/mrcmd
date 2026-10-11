mrcore_import "${MRCMD_DIR}/src/main.sh"
mrcore_import "${MRCMD_DIR}/src/core/validate.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-constants.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-debug-echo.sh"
mrcore_import "${MRCMD_DIR}/tests/mocks/mrcore-echo.sh"

################################################################################

function mrcmd_main_init_paths_valid_test() {
  local tmpDir
  local isSuccess=false

  tmpDir="$(mktemp -d)"
  mkdir "${tmpDir}/shared" "${tmpDir}/project"

  MRCMD_PLUGINS_DIR="${tmpDir}/shared"
  APPX_PLUGINS_DIR="${tmpDir}/project"

  ################################################################################

  if (mrcmd_main_init_paths) ; then
    isSuccess=true
  fi

  rm -rf "${tmpDir}"

  if [[ "${isSuccess}" != true ]]; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_main_init_paths_project_plugins_equal_shared_test() {
  local tmpDir
  local errorMessage=""
  local isSuccess=false

  function mrcore_echo_error() {
    echo "${1-}"
  }

  tmpDir="$(mktemp -d)"
  mkdir "${tmpDir}/shared"

  MRCMD_PLUGINS_DIR="${tmpDir}/shared"
  APPX_PLUGINS_DIR="${tmpDir}/shared"

  ################################################################################

  if errorMessage="$(mrcmd_main_init_paths)" ; then
    isSuccess=true
  fi

  rm -rf "${tmpDir}"

  if [[ "${isSuccess}" != false ]] ||
     [[ "${errorMessage}" != "Project plugins cannot run from ${MRCMD_INFO_CAPTION} shared plugins dir and its subdirectories" ]]; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_main_init_paths_project_plugins_inside_shared_test() {
  local tmpDir
  local errorMessage=""
  local isSuccess=false

  function mrcore_echo_error() {
    echo "${1-}"
  }

  tmpDir="$(mktemp -d)"
  mkdir -p "${tmpDir}/shared/sub"

  MRCMD_PLUGINS_DIR="${tmpDir}/shared"
  APPX_PLUGINS_DIR="${tmpDir}/shared/sub"

  ################################################################################

  if errorMessage="$(mrcmd_main_init_paths)" ; then
    isSuccess=true
  fi

  rm -rf "${tmpDir}"

  if [[ "${isSuccess}" != false ]] ||
     [[ "${errorMessage}" != "Project plugins cannot run from ${MRCMD_INFO_CAPTION} shared plugins dir and its subdirectories" ]]; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcmd_main_init_paths_project_plugins_inside_mrcmd_test() {
  local tmpDir
  local errorMessage=""
  local isSuccess=false

  function mrcore_echo_error() {
    echo "${1-}"
  }

  tmpDir="$(mktemp -d)"
  mkdir "${tmpDir}/shared"

  MRCMD_PLUGINS_DIR="${tmpDir}/shared"
  APPX_PLUGINS_DIR="${MRCMD_DIR}/tests"

  ################################################################################

  if errorMessage="$(mrcmd_main_init_paths)" ; then
    isSuccess=true
  fi

  rm -rf "${tmpDir}"

  if [[ "${isSuccess}" != false ]] ||
     [[ "${errorMessage}" != "Project plugins cannot run from ${MRCMD_INFO_CAPTION} dir and its subdirectories" ]]; then
    ${EXIT_ERROR}
  fi
}
