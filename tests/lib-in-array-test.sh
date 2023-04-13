#!/bin/bash

mrcore_import "${MRCMD_DIR}/src/core/lib.sh"

function mrcore_lib_in_array_search_item_in_array_test() {
  local searchItem="value2"
  local array=("value1" "value2" "value3")

  if ! mrcore_lib_in_array "${searchItem}" array[@] ; then
    ${EXIT_ERROR}
  fi
}

function mrcore_lib_in_array_search_item_not_in_array_test() {
  local searchItem="value4"
  local array=("value1" "value2" "value3")

  if mrcore_lib_in_array "${searchItem}" array[@] ; then
    ${EXIT_ERROR}
  fi
}

function mrcore_lib_in_array_search_item_in_empty_array_test() {
  local searchItem="value1"
  local array=()

  if mrcore_lib_in_array "${searchItem}" array[@] ; then
    ${EXIT_ERROR}
  fi
}
