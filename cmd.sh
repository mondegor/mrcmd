#!/usr/bin/env bash
# chmod +x ./cmd.sh

readonly MRCMD_DIR=$(realpath "${BASH_SOURCE[0]}" | xargs dirname)
readonly APPX_DIR="."
readonly APPX_DIR_REAL=$(realpath "${APPX_DIR}")

MRCMD_PLUGINS_DIR=""
APPX_PLUGINS_DIR=""

source "${MRCMD_DIR}/src/core/bash.sh"
source "${MRCMD_DIR}/src/core/colors.sh"
source "${MRCMD_DIR}/src/core/debug.sh"
source "${MRCMD_DIR}/src/core/dotenv.sh"
source "${MRCMD_DIR}/src/core/echo.sh"
source "${MRCMD_DIR}/src/core/lib.sh"
source "${MRCMD_DIR}/src/core/os.sh"
source "${MRCMD_DIR}/src/core/validate.sh"
source "${MRCMD_DIR}/src/core/xtrace.sh"
source "${MRCMD_DIR}/src/plugins/depends.sh"
source "${MRCMD_DIR}/src/plugins/functions.sh"
source "${MRCMD_DIR}/src/plugins/init.sh"
source "${MRCMD_DIR}/src/plugins/lib.sh"
source "${MRCMD_DIR}/src/plugins/methods.sh"
source "${MRCMD_DIR}/src/plugins/state.sh"
source "${MRCMD_DIR}/src/config.sh"
source "${MRCMD_DIR}/src/export-config.sh"
source "${MRCMD_DIR}/src/help.sh"
source "${MRCMD_DIR}/src/info.sh"
source "${MRCMD_DIR}/src/init.sh"
source "${MRCMD_DIR}/src/install.sh"
source "${MRCMD_DIR}/src/main.sh"
source "${MRCMD_DIR}/src/start.sh"
source "${MRCMD_DIR}/src/stop.sh"
source "${MRCMD_DIR}/src/uninstall.sh"

mrcmd_main_run "$@"
