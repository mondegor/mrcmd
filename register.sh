#!/usr/bin/env bash
# chmod +x ./register.sh
# Registration of Mrcmd Tool for Linux

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

MRCMD_PATH="$(realpath "${BASH_SOURCE[0]}" | xargs dirname)/cmd.sh"
MRCMD_PATH_BIN=/usr/local/bin/mrcmd

if [ ! -f "${MRCMD_PATH}" ]; then
  echo "File '${MRCMD_PATH}' not found"
  exit
fi

if echo -e "#!/usr/bin/env bash\n${MRCMD_PATH} \"\$@\"" > "${MRCMD_PATH_BIN}"; then
  chmod +x "${MRCMD_PATH}" "${MRCMD_PATH_BIN}"
  echo "Mrcmd Tool has been successfully registered in ${MRCMD_PATH_BIN}"
fi
