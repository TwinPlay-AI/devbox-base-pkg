#!/bin/bash
set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

set -o pipefail

twinplay_base_pkg(){
    pip install --upgrade pip ; pip install -r "${PLUGIN_TWINPLAY_DIR}/twinplay.requirements.txt"
    pre-commit install
}

twinplay_base_files() {
    touch "${DEVBOX_PROJECT_ROOT}/.env"

    # Create Python requirements files
    if [[ ! -d "${DEVBOX_PROJECT_ROOT}/requirements" ]] ; then
        mkdir -p "${DEVBOX_PROJECT_ROOT}/requirements"
    fi

    touch "${DEVBOX_PROJECT_ROOT}/requirements/production.txt"
    touch "${DEVBOX_PROJECT_ROOT}/requirements/develop.txt"

    touch "${DEVBOX_PROJECT_ROOT}/requirements/arm64.txt"
    touch "${DEVBOX_PROJECT_ROOT}/requirements/x86.txt"

    # Create project deps installation script
    if [[ ! -f "${DEVBOX_CONFIG_DIR}/twinplay/deps.sh" ]] ; then
        mkdir -p "${DEVBOX_CONFIG_DIR}/twinplay"
        cp "${PLUGIN_TWINPLAY_DIR}/conf/deps.sh" "${DEVBOX_CONFIG_DIR}/twinplay/deps.sh"
    fi

    # Create default project files
    local _twinplay_files_dir="${PLUGIN_TWINPLAY_DIR}/files"

    cp "${_twinplay_files_dir}/.pre-commit-config.yaml" "${DEVBOX_PROJECT_ROOT}/.pre-commit-config.yaml"
    cp "${_twinplay_files_dir}/CODE_OF_CONDUCT.md" "${DEVBOX_PROJECT_ROOT}/CODE_OF_CONDUCT.md"
    cp "${_twinplay_files_dir}/CONTRIBUTING.md" "${DEVBOX_PROJECT_ROOT}/CONTRIBUTING.md"
    cp "${_twinplay_files_dir}/.activate" "${DEVBOX_PROJECT_ROOT}/.activate"
    cp --recursive "${_twinplay_files_dir}/.github" "${DEVBOX_PROJECT_ROOT}"
}

main() {
    twinplay_base_pkg
    twinplay_base_files
}

main "$@"
