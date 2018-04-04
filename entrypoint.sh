#!/bin/bash -e

source ./kms_utils.sh

STRING_VAULT_HOST=${STRING_VAULT_HOST:=vault.service.eos.saas.stratio.com}
VAULT_PORT=${VAULT_PORT:=8200}

CLUSTER="${CLUSTER:=userland}"
INSTANCE="${INSTANCE:=postgrestls}"
USER="${USER:=postgres}"
CERTPATH="/tmp"

IFS_OLD=$IFS
IFS=',' read -r -a VAULT_HOSTS <<< "$STRING_VAULT_HOST"


if [[ ${VAULT_ROLE_ID} ]] && [[ ${VAULT_SECRET_ID} ]];
then
  # Login to Vault to get VAULT_TOKEN using dynamic authentication
  login
fi

getCAbundle ${CERTPATH} "PEM"
getCert ${CLUSTER} ${INSTANCE} ${USER} "PEM" ${CERTPATH}

fold -w64 /tmp/ca-bundle.pem > /ca-bundle.pem
fold -w64 /tmp/${USER}.key > /${USER}.key
fold -w64 /tmp/${USER}.pem > /${USER}.pem

chmod 600 /*.key
chmod 600 /*.pem

/postgres_exporter --web.listen-address=:$PORT0
