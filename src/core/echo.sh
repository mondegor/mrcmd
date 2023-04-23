
function mrcore_echo_ok() {
  mrcore_echo_message "${CC_BG_GREEN}" "${1:?}" "${2-}"
}

function mrcore_echo_notice() {
  mrcore_echo_message "${CC_BG_BLUE}" "${1:?}" "${2-}"
}

function mrcore_echo_sample() {
  mrcore_echo_message "${CC_BG_GRAY}" "${1:?}" "${2-}"
}

function mrcore_echo_warning() {
  mrcore_echo_message "${CC_BG_YELLOW}" "${1:?}" "${2-}"
}

function mrcore_echo_error() {
  mrcore_echo_message "${CC_BG_RED}" "${1:?}" "${2-}"
}

function mrcore_echo_message() {
  local ccColor="${1:-}"
  local message="${2:?}"
  local indent=${3-}
  local length=$((${#message} + 3))

  if [ -n "${ccColor}" ]; then
    echo ""
    echo -en "${indent}${ccColor}"
    mrcore_lib_repeat_string " " ${length}
    echo -e "${CC_END}"

    echo -e "${indent}${ccColor} ${message}  ${CC_END}"
    # echo >&2 -e "${indent}${ccColor} ${message}  ${CC_END}"

    echo -en "${indent}${ccColor}"
    mrcore_lib_repeat_string " " ${length}
    echo -e "${CC_END}"
  else
    echo -e "${indent} ${message}"
  fi

  echo ""
}

function mrcore_echo_var() {
  local varName="${1:?}"
  local varValue="${2-}"
  local valueColor="${CC_RED}"

  if [ -z "${varValue}" ]; then
    varValue="NULL"
  elif [[ "${varValue}" =~ ^[0-9]+$ ]]; then
    valueColor="${CC_CYAN}"
  elif [[ "${varValue}" != true ]] && [[ "${varValue}" != false ]]; then
    valueColor="${CC_GREEN}"
    varValue="\"${varValue}\""
  fi

  echo -e "  ${varName} = ${valueColor}${varValue}${CC_END}"
}
