
function mrcore_tty_init() {
  local os
  os="$(uname -s)"

  # Do something under 32 bits Windows NT platform
  if [[ "${os:0:5}" == MINGW ]]; then
    mrcore_debug_echo ${DEBUG_LEVEL_1} "${DEBUG_RED}" "winpty is on"
    readonly MRCORE_TTY_INTERFACE="winpty"
  else
    readonly MRCORE_TTY_INTERFACE=""
  fi
}
