#!/bin/sh
if [ $# -ne 1 ]; then
  echo "entrypoint requires the handler name to be the first argument" 1>&2
  exit 142
fi
export _HANDLER=index.handler

PAYLOAD_DIRECTORY=/var/events

RUNTIME_ENTRYPOINT=/var/runtime/bootstrap
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  # Run the server as daemon to send directly the request we want
  exec /usr/local/bin/aws-lambda-rie $RUNTIME_ENTRYPOINT &
  cat $PAYLOAD_DIRECTORY/$1 | grep -v '^\s*//' | curl -s -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" -H 'Content-Type: application/json' -d @-
else
  exec $RUNTIME_ENTRYPOINT
fi