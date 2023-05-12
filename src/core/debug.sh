
MRCORE_DEBUG_LEVEL=0
MRCORE_VERBOSE=false

readonly DEBUG_LEVEL_0=0
readonly DEBUG_LEVEL_1=1
readonly DEBUG_LEVEL_2=2
readonly DEBUG_LEVEL_3=3

function mrcore_debug_init() {
  readonly DEBUG_RED=${CC_BG_RED}
  readonly DEBUG_BLUE=${CC_BG_BLUE}
  readonly DEBUG_GREEN=${CC_BG_GREEN}
  readonly DEBUG_YELLOW=${CC_BG_YELLOW}

  mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_RED}" "MRCORE_DEBUG_LEVEL=${MRCORE_DEBUG_LEVEL}"

  if [[ "${MRCORE_VERBOSE}" == true ]]; then
    mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_RED}" "MRCORE_VERBOSE=true"
    set -x
  fi
}

function mrcore_debug_echo() {
  local level=${1:?}

  if [[ ${MRCORE_DEBUG_LEVEL} -ge ${level} ]]; then
    local debugCC="${2-}"
    local message="${3:?}"

    mrcore_echo_message "${debugCC}" "[DEBUG] ${message}"
  fi
}

function mrcore_debug_echo_call_function() {
  local funcName="${1:?}"
  shift

  local arguments="$@"
  mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_YELLOW}" "Call function: ${funcName}(${arguments})"
}

# using example: if mrcore_debug_level_validate "${level}" ; then
function mrcore_debug_level_validate() {
  local level=${1-}

  if [[ "${level}" =~ ^[${DEBUG_LEVEL_0}-${DEBUG_LEVEL_3}]$ ]]; then
    ${RETURN_TRUE}
  fi

  ${RETURN_FALSE}
}

function mrcore_debug_echo_array() {
  local array=("${!1:-}")
  declare -p array
}
