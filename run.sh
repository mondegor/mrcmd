#!/bin/bash
set -o pipefail -e

export MRCMD_VERSION="0.2.0"
export MRCMD_DIR
export APPX_DIR

MRCMD_DIR=$(realpath "${0}" | xargs dirname)
APPX_DIR=$(realpath ".")

source "${MRCMD_DIR}/core/console-colors.sh"
source "${MRCMD_DIR}/core/debug.sh"
source "${MRCMD_DIR}/core/debug-xtrace.sh"
source "${MRCMD_DIR}/core/echo.sh"
source "${MRCMD_DIR}/core/help.sh"
source "${MRCMD_DIR}/core/lib.sh"
source "${MRCMD_DIR}/core/main.sh"
source "${MRCMD_DIR}/core/plugins.sh"
source "${MRCMD_DIR}/core/plugins-available.sh"
source "${MRCMD_DIR}/core/plugins-scripts.sh"
source "${MRCMD_DIR}/core/plugins-scripts-available.sh"
source "${MRCMD_DIR}/core/validate.sh"

mrcmd_run "$@"
