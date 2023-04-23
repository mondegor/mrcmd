function mrcore_lib_repeat_string() {
  mrcore_xtrace_store_and_off

  local str="${1:?}"
  local length=${2:?}
  local range
  local stub

  range="$(seq 1 ${length})"

  for stub in ${range}; do echo -n "${str}"; done

  mrcore_xtrace_restore
}

# using example: if mrcore_lib_func_exists "${funcName}" ; then
function mrcore_lib_func_exists() {
  local funcName="${1:?}"

  if [ -n "$(declare -F "${funcName}")" ]; then
    ${RETURN_TRUE}
  fi

  ${RETURN_FALSE}
}

# using example: if mrcore_lib_check_string_suffix "${str}" "${suffix}" ; then
function mrcore_lib_check_string_suffix() {
  local str="${1:?}"
  local suffix="${2:?}"
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

# using example: if mrcore_lib_in_array "${searchItem}" array[@] ; then
function mrcore_lib_in_array() {
  local searchItem="${1:?}"
  local array=("${!2-}")
  local item

  for item in "${array[@]}"; do
    if [[ "${item}" == "${searchItem}" ]]; then
      ${RETURN_TRUE}
    fi
  done

  ${RETURN_FALSE}
}

# using example: $(mrcmd_lib_implode "${separator}" "${array}")
function mrcmd_lib_implode() {
  local separator="${1:?}"
  local array=("${!2-}")
  local length=${#separator}
  local result=""

  for item in "${array[@]}"; do
    result="${result}${separator}${item}"
  done

  echo "${result:${length}}"
}

# using example: $(mrcore_lib_string_to_uppercase "${string}")
function mrcore_lib_string_to_uppercase() {
  local str="${1:?}"
  # echo "${str}" | tr "[:lower:]" "[:upper:]"
  echo "${str^^}"
}

function mrcore_lib_mkdir() {
  local dirPath="${1:?}"

  if [ ! -d "${dirPath}" ]; then
    mkdir -m 0755 "${dirPath}"
    mrcore_echo_ok "Dir '${dirPath}' created"
  fi
}

function mrcore_lib_rm() {
  local filePath="${1:?}"

  if [ -f "${filePath}" ]; then
    rm "${filePath}"
    mrcore_echo_error "File '${filePath}' removed"
  fi
}

function mrcore_lib_rmdir() {
  local dirPath="${1:?}"

  if [ -d "${dirPath}" ]; then
    chmod -R 0777 "${dirPath}"
    rm -R "${dirPath}"
    mrcore_echo_error "Dir '${dirPath}' removed"
  fi
}