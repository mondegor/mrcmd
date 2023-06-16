set -euo pipefail
IFS=$'\n\t'

readonly CMD_SEPARATOR=$'\t'

readonly FD_STDIN=0
readonly FD_STDOUT=1
readonly FD_STDERR=2

readonly ERROR_CODE_FALSE=1
readonly ERROR_CODE_UNKNOWN_ERROR=16
readonly ERROR_CODE_UNKNOWN_COMMAND=17

readonly RETURN_TRUE=$'return\t0'
readonly RETURN_FALSE=$'return\t1'
readonly RETURN_UNKNOWN_ERROR=$'return\t16'
readonly RETURN_UNKNOWN_COMMAND=$'return\t17'
readonly EXIT_SUCCESS=$'exit\t0'
readonly EXIT_ERROR=$'exit\t1'

function mrcore_import() {
  local sourcePath="${1:?}"

  if ! source "${sourcePath}" ; then
    ${EXIT_ERROR}
  fi
}

# using example: $(mrcore_get_shell "${shellName}")
function mrcore_get_shell() {
  local shellName="${1-}"

  if [[ "${shellName}" != "sh" ]] && [[ "${shellName}" != "bash" ]]; then
    shellName="sh"
  fi

  echo "${shellName}"
}

# using example: $(mrcore_tool_exists "${toolName}")
function mrcore_tool_exists() {
  local toolName="${1:?}"

  # WARNING: ${toolName} must be without quotes
  if [[ $(${toolName} 2>&1) =~ "command not found" ]]; then
    echo false
  else
    echo true
  fi
}
