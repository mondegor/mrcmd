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

# using example: $(mrcore_lib_flag_to_int "${string}")
function mrcore_lib_flag_to_int() {
  local flag="${1:?}"

  case "${flag}" in
    true | True | on | On | 1)
      echo "1"
      ;;

    *)
      echo "0"
      ;;

  esac
}

function mrcore_lib_mkdir() {
  local dirPath="${1:?}"

  if [ ! -d "${dirPath}" ]; then
    if ! mkdir -p -m 0755 "${dirPath}" ; then
      ${EXIT_ERROR}
    fi

    mrcore_echo_ok "Dir '${dirPath}' created"
  fi
}

function mrcore_lib_rm() {
  local filePath="${1:?}"

  if [ -f "${filePath}" ]; then
    if ! rm "${filePath}" ; then
      ${EXIT_ERROR}
    fi

    mrcore_echo_warning "File '${filePath}' removed"
  fi
}

function mrcore_lib_rmdir() {
  local dirPath="${1:?}"

  if [ -d "${dirPath}" ]; then
    if ! chmod -R 0777 "${dirPath}" ; then
      ${EXIT_ERROR}
    fi

    if ! rm -R "${dirPath}" ; then
      ${EXIT_ERROR}
    fi

    mrcore_echo_warning "Dir '${dirPath}' removed"
  fi
}

function mrcore_lib_rm_resource() {
  local resourcePath="${1:?}"

  if [ -f "${resourcePath}" ]; then
    mrcore_lib_rm "${resourcePath}"
  else
    mrcore_lib_rmdir "${resourcePath}"
  fi
}

# using example: $(mrcmd_plugins_lib_get_var_value "${varName}")
function mrcore_lib_get_var_value() {
  local varName="${1:?}"
  eval "echo \"\${${varName}-}\""
}
