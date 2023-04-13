set -euo pipefail
IFS=$'\n\t'

readonly CMD_SEPARATOR=$'\t'

readonly FD_STDIN=0
readonly FD_STDOUT=1
readonly FD_STDERR=2

readonly RETURN_TRUE=$'return\t0'
readonly RETURN_FALSE=$'return\t1'
readonly EXIT_SUCCESS=$'exit\t0'
readonly EXIT_ERROR=$'exit\t1'

function mrcore_import() {
  local sourcePath="${1:?}"
  if ! source "${sourcePath}" ; then
    ${EXIT_ERROR}
  fi
}
