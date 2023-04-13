
function mrcore_lib_repeat_string() {
  mrcore_xtrace_store_and_off

  local str=${1:?}
	local length=${2:?}
	local range
	local stub

	range="$(seq 1 ${length})"

  for stub in ${range}; do echo -n "${str}"; done

  mrcore_xtrace_restore
}

# using example: if mrcore_lib_function_exists "${functionName}" ; then
function mrcore_lib_function_exists() {
  local functionName=${1:?}

  if [ -n "$(declare -F "${functionName}")" ]; then
    ${RETURN_TRUE}
  fi

  ${RETURN_FALSE}
}

# using example: if mrcore_lib_check_string_suffix "${str}" "${suffix}" ; then
function mrcore_lib_check_string_suffix() {
  local str=${1:?}
  local suffix=${2:?}
  local length=${#str}
  local suffixLength=${#suffix}

  if [[ ${length} -ge ${suffixLength} ]]; then
    length=$((length - suffixLength))

    if [[ "${str:${length}:${suffixLength}}" == "${suffix}" ]]; then
      ${RETURN_TRUE}
    fi
  fi

  ${RETURN_FALSE}
}

# using example: if mrcore_lib_in_array_copy "${searchItem}" array[@] ; then
function mrcore_lib_in_array() {
  local searchItem=${1:?}
  local array=("${!2-}")
  local currentItem

  for currentItem in "${array[@]}"
  do
    if [[ "${currentItem}" == "${searchItem}" ]]; then
      ${RETURN_TRUE}
    fi
  done

  ${RETURN_FALSE}
}
