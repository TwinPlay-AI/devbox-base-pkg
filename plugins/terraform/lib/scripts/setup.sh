#!/bin/bash
set -eE -o functrace

failure() {
  local lineno=$1
  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

set -o pipefail

terraform_base_files() {
    if [[ ! -d "${INFRASTRUCTURE_PATH}/env" ]] ; then
        mkdir -p "${INFRASTRUCTURE_PATH}/env"
    fi

    touch "${INFRASTRUCTURE_PATH}/backend.tf"
    touch "${INFRASTRUCTURE_PATH}/main.tf"
    touch "${INFRASTRUCTURE_PATH}/outputs.tf"
    touch "${INFRASTRUCTURE_PATH}/providers.tf"
    touch "${INFRASTRUCTURE_PATH}/variables.tf"
    touch "${INFRASTRUCTURE_PATH}/version.tf"
    touch "${INFRASTRUCTURE_PATH}/env/${WORKSPACE:-production}.tfvars"
    touch "${INFRASTRUCTURE_PATH}/Makefile.project"

    cp "${PLUGIN_TERRAFORM_DIR}/files/Makefile" "${INFRASTRUCTURE_PATH}/Makefile"
}

main() {
    terraform_base_files
}

main "$@"
