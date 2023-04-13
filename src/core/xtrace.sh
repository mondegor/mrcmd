
#private
MRCORE_XTRACE_STORED=false

function mrcore_xtrace_store_and_off() {
  if [[ "${MRCORE_XTRACE_STORED}" == true ]]; then
    echo "Need to call method mrcore_xtrace_restore before!" 1>&2
    ${EXIT_ERROR}
  fi

  if [ -o xtrace ]; then
    set +x
    MRCORE_XTRACE_STORED=true
  fi
}

function mrcore_xtrace_restore() {
  if [[ "${MRCORE_XTRACE_STORED}" == true ]]; then
    set -x
    MRCORE_XTRACE_STORED=false
  fi
}
