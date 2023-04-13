#!/bin/bash

mrcore_import "${MRCMD_DIR}/src/core/lib.sh"

function mrcore_lib_check_string_suffix_true1_test() {
  local str="string.suffix"
  local suffix=".suffix"

  if ! mrcore_lib_check_string_suffix "${str}" "${suffix}" ; then
    ${EXIT_ERROR}
  fi
}

function mrcore_lib_check_string_suffix_true2_test() {
  local str=".suffix"
  local suffix=".suffix"

  if ! mrcore_lib_check_string_suffix "${str}" "${suffix}" ; then
    ${EXIT_ERROR}
  fi
}

function mrcore_lib_check_string_suffix_false_test() {
  local str="string.suffix"
  local suffix=".suffix1"

  if mrcore_lib_check_string_suffix "${str}" "${suffix}" ; then
    ${EXIT_ERROR}
  fi
}
