
function mrcmd_main_run() {
  mrcmd_main_parse_args "$@"
  mrcmd_main_init
  mrcmd_main_exec "${MRCMD_ARGS[@]}"
}

# private
function mrcmd_main_parse_args() {
  MRCORE_DOTENV_ARRAY=()
  APPX_PLUGINS_DIR=""

  # args without options
  MRCMD_ARGS=()

  while :; do
    case ${1-} in

      --debug)
        if ! mrcore_debug_level_validate "${2-}" ; then
          echo "--debug value: 0 - 4" 1>&2
          ${EXIT_ERROR}
        fi

        MRCORE_DEBUG_LEVEL="${2}"
        shift
        ;;

      -n | --no-color)
        MRCORE_USE_COLOR=false
        ;;

      -V | --verbose)
        MRCORE_VERBOSE=true
        ;;

      -v | --version)
        echo -e "${MRCMD_INFO_CAPTION} version ${MRCMD_INFO_VERSION}"
        ${EXIT_SUCCESS}
        ;;

      -d | --plugins-dir)
        if [[ -z "${2-}" ]]; then
          echo "-d --plugins-dir value: dir in $(realpath "${APPX_DIR}")/" 1>&2
          ${EXIT_ERROR}
        fi

        APPX_PLUGINS_DIR="${2}"
        shift
        ;;

      --env-file)
        if [[ -z "${2-}" ]]; then
          echo "--env-file value: file in $(realpath "${APPX_DIR}")/" 1>&2
          ${EXIT_ERROR}
        fi

        MRCORE_DOTENV_ARRAY+=("${APPX_DIR}/${2}")
        shift
        ;;

      *)
        if [[ -z "${1-}" ]]; then
          return
        fi

        MRCMD_ARGS+=("${1}")
        ;;
    esac

    shift
  done
}

# private
function mrcmd_main_init() {
  mrcore_colors_init
  mrcore_debug_init
  mrcore_tty_init
  mrcore_dotenv_init
  mrcmd_main_init_paths
  mrcmd_plugins_init
}

# private
function mrcmd_main_init_paths() {
  mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_GREEN}" "Current run path: $(realpath "${APPX_DIR}")"

  if [ -n "${APPX_PLUGINS_DIR}" ]; then
    APPX_PLUGINS_DIR="${APPX_DIR}/${APPX_PLUGINS_DIR}"

    mrcore_validate_dir_required "${MRCMD_INFO_CAPTION} plugins directory" "${APPX_PLUGINS_DIR}"

    if [[ "$(realpath "${APPX_PLUGINS_DIR}")/" == "${MRCMD_DIR}/"* ]]; then
      mrcore_echo_error "${MRCMD_INFO_CAPTION} plugins cannot run from mrcmd dir and its subdirectories"
      ${EXIT_ERROR}
    fi
  fi

  # пути к общим плагинам и скриптам, а также к плагинам и скриптам проекта
  MRCMD_PLUGINS_DIR_ARRAY=("${MRCMD_DIR}/plugins" "${APPX_PLUGINS_DIR}")
}

# private
function mrcmd_main_exec {
  local currentCommand=${1-}

  if [ -n "${currentCommand}" ]; then
    shift

    case ${currentCommand} in

      config | help)
        local pluginName=${1-}

        if [ -n "${pluginName}" ]; then
          if mrcore_lib_in_array "${pluginName}" MRCMD_PLUGINS_LOADED_ARRAY[@] ; then
            mrcmd_help_exec_head
            mrcmd_plugins_exec_method "force" "${pluginName}" "${currentCommand}"
            return
          fi

          currentCommand="${currentCommand} ${pluginName}"
        else
          mrcmd_${currentCommand}_exec
          mrcmd_plugins_exec_group_methods "${currentCommand}"
          return
        fi
        ;;

      *)
        if mrcore_lib_in_array "${currentCommand}" MRCMD_EXECUTABLE_PLUGIN_METHODS_ARRAY[@] ; then
          mrcmd_plugins_exec_group_methods "${currentCommand}"
          return
        fi

        if mrcore_lib_in_array "${currentCommand}" MRCMD_PLUGINS_LOADED_ARRAY[@] ; then
          mrcmd_plugins_exec_method "normal" "${currentCommand}" "$@"
          return
        fi
        ;;

    esac

    mrcore_echo_error "Command ${currentCommand} is unknown"
  fi

  mrcore_echo_sample "Run '${MRCMD_INFO_NAME} help' for usage"
}

# using example: if mrcmd_main_is_shared_dir_index "${dirArrayIndex}" ; then
function mrcmd_main_is_shared_dir_index() {
  local dirArrayIndex="${1:?}"
  local constDirCoreIndex=0

  if [[ ${dirArrayIndex} -eq ${constDirCoreIndex} ]]; then
    ${RETURN_TRUE}
  fi

  ${RETURN_FALSE}
}

# using example: if mrcmd_main_is_project_dir_index "${dirArrayIndex}" ; then
function mrcmd_main_is_project_dir_index() {
  local dirArrayIndex="${1:?}"
  local constDirProjectIndex=1

  if [[ ${dirArrayIndex} -eq ${constDirProjectIndex} ]]; then
    ${RETURN_TRUE}
  fi

  ${RETURN_FALSE}
}
