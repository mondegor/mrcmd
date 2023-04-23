# https://misc.flogisoft.com/bash/tip_colors_and_formatting

MRCORE_USE_COLOR=true

function mrcore_colors_init() {
  if [[ -t ${FD_STDERR} ]] && [[ "${MRCORE_USE_COLOR}" == true ]] && [[ "${TERM-}" != "dumb" ]]; then
    # readonly CC_DEFAULT="\e[39m"
    readonly CC_END="\e[0m"

    readonly CC_BLUE="\e[94m"
    readonly CC_CYAN="\e[36m"
    readonly CC_GREEN="\e[32m"
    readonly CC_LIGHT_GREEN="\e[92m"
    # readonly CC_MAGENTA="\e[95m"
    readonly CC_RED="\e[91m"
    readonly CC_YELLOW="\e[33m"
    readonly CC_GRAY="\e[90m"

    readonly CC_BG_BLUE="\e[39;104m"
    readonly CC_BG_GRAY="\e[39;100m"
    readonly CC_BG_GREEN="\e[30;42m"
    readonly CC_BG_RED="\e[39;41m"
    readonly CC_BG_YELLOW="\e[30;43m"
  else
    # readonly CC_DEFAULT=""
    readonly CC_END=""

    readonly CC_BLUE=""
    readonly CC_CYAN=""
    readonly CC_GREEN=""
    readonly CC_LIGHT_GREEN=""
    # readonly CC_MAGENTA=""
    readonly CC_RED=""
    readonly CC_YELLOW=""
    readonly CC_GRAY=""

    readonly CC_BG_BLUE=""
    readonly CC_BG_GRAY=""
    readonly CC_BG_GREEN=""
    readonly CC_BG_RED=""
    readonly CC_BG_YELLOW=""
  fi
}
