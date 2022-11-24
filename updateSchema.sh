#!/bin/sh
if [ -z $1 ]; then echo "must provide authentication token!" && exit; fi

BEARER_TOKEN=$1
AGENT_API_URL=${2:-http://localhost:9000}
SCHEMA_MUTATION_FILE_PATH=${2:-playground/playground.toml}
SCHEMA_MUTATION=`cat $SCHEMA_MUTATION_FILE_PATH`

curl --location --request PATCH "$AGENT_API_URL/api/v1/schema" \
--header 'Content-Type: application/toml' \
--header 'Accept: appplication/json' \
--header "Authorization: Bearer token $BEARER_TOKEN" \
--data-raw "$SCHEMA_MUTATION"