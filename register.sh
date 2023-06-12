#!/usr/bin/env bash
# chmod +x ./register.sh

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

MRCMD_PATH="$(realpath "${BASH_SOURCE[0]}" | xargs dirname)/cmd.sh"
MRCMD_PATH_BIN=/usr/local/bin/mrcmd

if echo -e "#!/usr/bin/env bash\n\n${MRCMD_PATH} \"\$@\"" > "${MRCMD_PATH_BIN}"; then
  chmod +x "${MRCMD_PATH_BIN}"
  echo "Mrcmd has been successfully registered in ${MRCMD_PATH_BIN}"
fi
