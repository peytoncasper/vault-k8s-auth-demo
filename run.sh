#!/bin/bash
#export VAULT_ADDR=${VAULT_ADDR:-http://vault:8200}

# Get our token
export SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export SA_TOKEN=${SA_TOKEN:-INVALID}

# Authenticate via REST.
export VAULT_AUTH=$(curl --request POST \
	--data "{\"jwt\": \"$SA_TOKEN\", \"role\": \"demo\"}" \
	$VAULT_ADDR/v1/auth/kubernetes/login)

# Set VAULT_TOKEN
export VAULT_TOKEN=$(echo $VAULT_AUTH | jq -r .auth.client_token)
export VAULT_TOKEN=${VAULT_TOKEN:-INVALID}

# Fetch secrets
# Fetch a KV
export KV=$(curl -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/openshift/test)

echo $KV
