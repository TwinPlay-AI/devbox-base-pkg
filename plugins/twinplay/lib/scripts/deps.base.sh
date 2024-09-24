#!/bin/bash
set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

set -o pipefail

setup_virtualenv(){
  mkdir -pv .venv

  if [[ "$(python3 --version)" == *"Python 3.12"* ]] ; then
    python3 -m venv .venv
  else
    pip3 install --upgrade virtualenv
    python3 -m virtualenv .venv
  fi
}

main(){
  echo "[INFO] Installing base dependencies"

  local _arg_requirements_to_install=${1}
  local _arch
  _arch=$(uname -m)

  if [[ -z "${_arg_requirements_to_install}" ]]; then
    _arg_requirements_to_install=("production" "develop")
  else
    _arg_requirements_to_install=(${_arg_requirements_to_install})
  fi

  python3 -m pip install --upgrade pip
  python3 -m pip install wheel

  for _req in "${_arg_requirements_to_install[@]}"; do
    if [[ ! -f "${DEVBOX_PROJECT_ROOT}/requirements/${_req}.txt" ]]; then
      echo "[ERROR] ${DEVBOX_PROJECT_ROOT}/requirements/${_req}.txt not found"
      exit 1
    fi

    echo "[INFO] Installing ${_req} requirements"
    pip3 install -r "${DEVBOX_PROJECT_ROOT}/requirements/${_req}.txt"
  done

  if [[ "${_arch}" == "arm64" ]] || [[ "${_arch}" == "aarch64" ]]; then
    pip3 install -r "${DEVBOX_PROJECT_ROOT}/requirements/arm64.txt"
  else
    pip3 install -r "${DEVBOX_PROJECT_ROOT}/requirements/x86.txt"
  fi
}

main "$@"
