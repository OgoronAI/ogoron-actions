#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <action-name> <target-dir>" >&2
  exit 2
fi

ACTION_NAME="$1"
TARGET_DIR="$2"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${ROOT_DIR}/${ACTION_NAME}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Unknown action directory: ${SOURCE_DIR}" >&2
  exit 2
fi

if [[ ! -d "${TARGET_DIR}/.git" ]]; then
  echo "Target dir must be a git checkout with .git: ${TARGET_DIR}" >&2
  exit 2
fi

clean_target() {
  shopt -s dotglob nullglob
  for path in "${TARGET_DIR}"/*; do
    [[ "$(basename "$path")" == ".git" ]] && continue
    rm -rf "$path"
  done
  shopt -u dotglob nullglob
}

copy_common_files() {
  cp "${ROOT_DIR}/LICENSE" "${TARGET_DIR}/LICENSE"
  cp "${ROOT_DIR}/SECURITY.md" "${TARGET_DIR}/SECURITY.md"
  cp "${ROOT_DIR}/.gitignore" "${TARGET_DIR}/.gitignore"
}

copy_action_files() {
  cp "${SOURCE_DIR}/README.md" "${TARGET_DIR}/README.md"
  cp "${SOURCE_DIR}/action.yml" "${TARGET_DIR}/action.yml"
  mkdir -p "${TARGET_DIR}/scripts"
  cp -R "${SOURCE_DIR}/scripts/." "${TARGET_DIR}/scripts/"
}

ensure_root_install_script() {
  if grep -q '../setup/scripts/install-ogoron.sh' "${TARGET_DIR}/action.yml"; then
    cp "${ROOT_DIR}/setup/scripts/install-ogoron.sh" "${TARGET_DIR}/scripts/install-ogoron.sh"
    sed -i 's#\.\./setup/scripts/install-ogoron\.sh#scripts/install-ogoron.sh#g' "${TARGET_DIR}/action.yml"
  fi
}

clean_target
copy_common_files
copy_action_files
ensure_root_install_script

printf 'exported action=%s target=%s\n' "${ACTION_NAME}" "${TARGET_DIR}"
