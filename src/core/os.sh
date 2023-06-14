
function mrcore_os_init() {
  local os
  os="$(uname -s)"

  # Do something under 32 bits Windows NT platform
  if [[ "${os:0:5}" == "MINGW" ]]; then
    mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_RED}" "winpty is on"
    readonly MRCORE_IS_WIN=true
    readonly MRCORE_TTY_INTERFACE="winpty"
  else
    readonly MRCORE_IS_WIN=false
    readonly MRCORE_TTY_INTERFACE=""
  fi
}

# using example: $(mrcmd_os_realpath "${string}")
function mrcmd_os_realpath() {
  local path="${1:?}"
  mrcmd_os_path "$(realpath "${path}")"
}

# using example: $(mrcmd_os_path "${string}")
function mrcmd_os_path() {
  local path="${1:?}"

  if [[ "${MRCORE_IS_WIN}" == true ]] &&
     [[ "${path:0:1}" == "/" ]] && [[ "${path:1:1}" != "/" ]]; then
    path="/${path}"
  fi

  echo "${path}"
}

# using example: $(mrcore_os_path_win_to_unix "${string}")
function mrcore_os_path_win_to_unix() {
  local path="${1:?}"
  local letter="${path%:*}"

  if [[ "${letter}" != "${path}" ]]; then
    path="/${letter,,}${path#*:}"
  fi

  echo "${path//\\/\/}"
}
