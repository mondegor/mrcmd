#!/bin/bash

mrcmd_repeat_string() {
  mrcmd_xtrace_store_and_off

  local STR=${1:?}
	local LENGTH=${2:?}
	local RANGE
	local STUB

	RANGE="$(seq 1 ${LENGTH})"

  for STUB in ${RANGE}; do echo -n "${STR}"; done

  mrcmd_xtrace_restore
}

# only for using as: $(mrcmd_function_exists "${NAME}")
mrcmd_function_exists() {
  local NAME=${1:?}

  if [ -n "$(declare -F "${NAME}")" ]; then
    echo "true"
    exit 0
  fi

  echo "false"
  exit 0
}

# only for using as: $(mrcmd_get_string_suffix "${STR}" ${SUFFIX_LENGTH})
mrcmd_get_string_suffix() {
  local STR=${1:?}
  local SUFFIX_LENGTH=${2:?}
  local LENGTH=${#STR}

  if [[ ${LENGTH} -lt ${SUFFIX_LENGTH} ]]; then
    mrcmd_echo_message_error "Length ${LENGTH} of ${STR} is less then ${SUFFIX_LENGTH}"
    exit 1
  fi

  LENGTH=$((${LENGTH} - ${SUFFIX_LENGTH}))

  echo "${STR:${LENGTH}:${SUFFIX_LENGTH}}"
  exit 0
}

# only for using as: $(mrcmd_in_array "${SEARCH_ITEM}" ARRAY[@])
mrcmd_in_array() {
  local SEARCH_ITEM=${1:?}
  local ARRAY=("${!2}")
  local ITEM

  for ITEM in "${ARRAY[@]}"
  do
    if [[ "${ITEM}" == "${SEARCH_ITEM}" ]]; then
      echo "true"
      exit 0
    fi
  done

  echo "false"
  exit 0
}

# only for using as: $(mrcmd_get_tmp_file_path)
mrcmd_get_tmp_file_path() {
  local TMP_DIR="${MRCMD_DIR}/tmp"

  if [ ! -d "${TMP_DIR}" ]; then
    mkdir -m 0755 "${TMP_DIR}"
  fi

  echo "${TMP_DIR}/$(date +%s%N | xargs printf %x)"
  exit 0
}
