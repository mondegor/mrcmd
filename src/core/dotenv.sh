
# used: MRCORE_DOTENV_ARRAY

function mrcore_dotenv_init() {
  if [ "${#MRCORE_DOTENV_ARRAY[@]}" -eq 0 ]; then
    mrcore_debug_echo ${DEBUG_LEVEL_3} "${DEBUG_YELLOW}" "MRCORE_DOTENV_ARRAY is empty"
    return
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

function mrcore_dotenv_init_var() {
  local varName="${1:?}"
  eval local varValue="\"\${${varName}-}\""

  if [ -z "${varValue}" ]; then
    local varDefault="${2-}"
    eval export ${varName}="\"${varDefault}\""
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
  eval local varValue="\"\${${varName}-}\""

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
