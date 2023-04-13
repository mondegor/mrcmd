#!/bin/bash

mrcore_import "${MRCMD_DIR}/src/core/lib.sh"

function mrcore_lib_function_exists_test_function() {
  local TEST_VAR;
}

function mrcore_lib_function_exists_found_test() {
  local functionName="mrcore_lib_function_exists_test_function"

  if ! mrcore_lib_function_exists "${functionName}" ; then
    ${EXIT_ERROR}
  fi
}

function mrcore_lib_in_array_search_item_not_found_test() {
  local functionName="mrcore_lib_function_exists_test_function2"

  if mrcore_lib_function_exists "${functionName}" ; then
    ${EXIT_ERROR}
  fi
}
