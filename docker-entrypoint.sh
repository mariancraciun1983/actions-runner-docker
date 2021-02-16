#!/bin/bash

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "GITHUB_TOKEN env is not set (check: https://github.com/settings/tokens)"
  exit 1
fi

if [[ -z "${GITHUB_TOKEN_URL}" ]]; then
  echo "GITHUB_TOKEN_URL env is not set  (eg: https://api.github.com/repos/OWNER/actions/runners/registration-token)"
  exit 1
fi

if [[ -z "${GITHUB_REGISTER_URL}" ]]; then
  echo "GITHUB_REGISTER_URL env is not set   (eg: https://github.com/OWNER OR https://github.com/OWNER/REPO)"
  exit 1
fi

if [[ -z "${GITHUB_WORKER_LABELS}" ]]; then
  echo "GITHUB_WORKER_LABELS env is not set   (eg: kubernetes,dev)"
  exit 1
fi


echo "Fetching token from ${GITHUB_TOKEN_URL}"
WORKER_TOKEN=$(curl -s -X POST -H "Authorization: token ${GITHUB_TOKEN}" "${GITHUB_TOKEN_URL}" | jq -r .token)

EXIT_CODE="$?"
if [ "$EXIT_CODE" != 0 ]
then
  echo "Failed fetching the token"
  exit $EXIT_CODE
fi

configure() {
  echo "Registering worker for ${GITHUB_REGISTER_URL}"
  ./config.sh \
    --url ${GITHUB_REGISTER_URL} \
    --labels ${GITHUB_WORKER_LABELS} \
    --unattended \
    --token "${WORKER_TOKEN}"
}

trap_signals() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

remove() {
    local SIGNAL=${1}
    echo "Unregistering worker due to ${SIGNAL}"
    ./config.sh remove --unattended --token "${WORKER_TOKEN}"
}

start() {
    echo "Starting worker in background"
    ./run.sh &
}

trap_signals remove INT ABRT TERM

configure

start

wait $!
