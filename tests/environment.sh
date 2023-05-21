#!/usr/bin/env bash

readonly MRCMD_DIR=$(realpath "${BASH_SOURCE[0]}" | xargs dirname | xargs dirname)
readonly APPX_DIR=$(realpath "${BASH_SOURCE[0]}" | xargs dirname)
readonly APPX_DIR_REAL=${APPX_DIR}

source "${MRCMD_DIR}/src/core/bash.sh"
source "${MRCMD_DIR}/src/info.sh"
