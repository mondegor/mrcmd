
mrcore_import "${MRCMD_DIR}/src/core/lib.sh"

function mrcore_lib_func_exists_test_function() {
  local TEST_VAR;
}

################################################################################

function mrcore_lib_func_exists_found_test() {
  local funcName="mrcore_lib_func_exists_test_function"

  if ! mrcore_lib_func_exists "${funcName}" ; then
    ${EXIT_ERROR}
  fi
}

################################################################################

function mrcore_lib_in_array_search_item_not_found_test() {
  local funcName="mrcore_lib_func_exists_test_function2"

  if mrcore_lib_func_exists "${funcName}" ; then
    ${EXIT_ERROR}
  fi
}
