
readonly REGEXP_PATTERN_FILE_NAME="^[a-zA-Z0-9_.-]+$"
readonly REGEXP_PATTERN_FILE_PREFIX="^[a-zA-Z0-9-]+$"

function mrcore_validate_value_required() {
  local CAPTION=${1:?}
  local STR=${2-}

  if [ -z "${STR}" ]; then
    mrcore_echo_error "${CAPTION} required"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_value() {
  local CAPTION=${1:?}
  local PATTERN=${2:?}
  local STR=${3:?}

  if [[ ! "${STR}" =~ ${PATTERN} ]]; then
    mrcore_echo_error "${CAPTION} \"${STR}\" contains invalid characters, allowed characters: ${PATTERN}"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_resource_exists() {
  local CAPTION=${1:?}
  local RESOURCE_PATH=${2:?}

  if [ -e "${RESOURCE_PATH}" ]; then
    mrcore_echo_error "${CAPTION} ${RESOURCE_PATH} already exists"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_file_required() {
  local CAPTION=${1:?}
  local FILE_PATH=${2:?}

  if [ ! -f "${FILE_PATH}" ]; then
    mrcore_echo_error "${CAPTION} ${FILE_PATH} not found"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_dir_required() {
  local CAPTION=${1:?}
  local DIR_PATH=${2:?}

  if [ ! -d "${DIR_PATH}" ]; then
    mrcore_echo_error "${CAPTION} ${DIR_PATH} not found"
    ${EXIT_ERROR}
  fi
}
