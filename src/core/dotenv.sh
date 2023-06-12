
# used: MRCORE_DOTENV_ARRAY
readonly MRCORE_DOTENV_DEFAULT="${APPX_DIR}/.env"
readonly MRCORE_DOTENV_EXPORTED="${APPX_DIR}/.env.exported"

function mrcore_dotenv_init() {
  if [ ${#MRCORE_DOTENV_ARRAY[@]} -eq 0 ]; then
    if [ -f "${MRCORE_DOTENV_DEFAULT}" ]; then
      MRCORE_DOTENV_ARRAY+=("${MRCORE_DOTENV_DEFAULT}")
    else
      mrcore_debug_echo ${DEBUG_LEVEL_2} "${DEBUG_RED}" "MRCORE_DOTENV_ARRAY is empty"
      return
    fi
  fi

  set -o allexport
  local dotEnvFilePath

  for dotEnvFilePath in "${MRCORE_DOTENV_ARRAY[@]}"
  do
    mrcore_validate_file_required "Project env file" "${dotEnvFilePath}"
    source "${dotEnvFilePath}"
  done

  set +o allexport
}

# using example: $(mrcore_dotenv_get_first)
function mrcore_dotenv_get_first() {
  if [[ ${#MRCORE_DOTENV_ARRAY[@]} -gt 0 ]]; then
    echo "${MRCORE_DOTENV_ARRAY[0]}"
    return
  fi

  echo "${MRCORE_DOTENV_DEFAULT}"
}

function mrcore_dotenv_init_var() {
  local varName="${1:?}"
  eval "local varValue=\"\${${varName}-}\""

  if [ -z "${varValue}" ]; then
    local varDefault="${2-}"
    eval "export ${varName}=\"${varDefault}\""
  fi
}

function mrcore_dotenv_init_var_array() {
  local varNames=("${!1}")
  local varDefaults=("${!2}")
  local i=0

  for varName in "${varNames[@]}"
  do
    mrcore_dotenv_init_var "${varName}" "${varDefaults[${i}]}"
    i=$((i + 1))
  done
}

function mrcore_dotenv_echo_var() {
  local varName="${1:?}"
  eval "local varValue=\"\${${varName}-}\""

  mrcore_echo_var "${varName}" "${varValue}"
}

function mrcore_dotenv_echo_var_array() {
  local varNames=("${!1}")
  local varName

  for varName in "${varNames[@]}"
  do
    mrcore_dotenv_echo_var "${varName}"
  done
}

function mrcore_dotenv_export_var() {
  local varName="${1:?}"
  eval "local varValue=\"\${${varName}-}\""
  cat >> "${MRCORE_DOTENV_EXPORTED}" <<< "# ${varName}=${varValue}"
}

function mrcore_dotenv_export_var_array() {
  local varNames=("${!1}")
  local varName

  for varName in "${varNames[@]}"
  do
    mrcore_dotenv_export_var "${varName}"
  done
}
