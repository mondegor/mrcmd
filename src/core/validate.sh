
readonly REGEXP_PATTERN_NAME="^[a-zA-Z][a-zA-Z0-9]*$"
readonly REGEXP_PATTERN_FILE_NAME="^[a-zA-Z0-9_.-]+$"
readonly REGEXP_PATTERN_FILE_PREFIX="^[a-zA-Z0-9-]+$"
readonly REGEXP_PATTERN_URL="^[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$"

function mrcore_validate_value_required() {
  local caption="${1:?}"
  local str="${2?}"

  if [ -z "${str}" ]; then
    mrcore_echo_error "${caption} required"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_value() {
  local caption="${1:?}"
  local pattern="${2:?}"
  local str="${3?}"

  if [[ ! "${str}" =~ ${pattern} ]]; then
    mrcore_echo_error "${caption} '${str}' contains invalid characters, allowed characters: ${pattern}"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_resource_exists() {
  local caption="${1:?}"
  local resourcePath="${2?}"

  if [ -e "${resourcePath}" ]; then
    mrcore_echo_error "${caption} '${resourcePath}' already exists"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_resource_required() {
  local caption="${1:?}"
  local resourcePath="${2?}"

  if [ ! -e "${resourcePath}" ]; then
    mrcore_echo_error "${caption} '${resourcePath}' not found"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_file_required() {
  local caption="${1:?}"
  local filePath="${2?}"

  if [ ! -f "${filePath}" ]; then
    mrcore_echo_error "${caption} '${filePath}' not found"
    ${EXIT_ERROR}
  fi
}

function mrcore_validate_dir_required() {
  local caption="${1:?}"
  local dirPath="${2?}"

  if [ ! -d "${dirPath}" ]; then
    mrcore_echo_error "${caption} '${dirPath}' not found"
    ${EXIT_ERROR}
  fi
}