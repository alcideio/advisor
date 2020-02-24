# Alcide Advisor Vault integration Examples

this example runs Alcide advisor as a kubernetes cron job.
the resaults are exported to S3 bucket. with credencials supplied by HashiCorp vault, via vault-agent integration.

this example make use of Vault installed in cluster.

---
### Vault
* #### install
  please follow the documentation on HashiCorp website - [vault-helm](https://github.com/hashicorp/vault-helm)
* #### configure
  1. `kubectl exec -ti vault-0 /bin/sh`
  2. create a policy
  ```
  #> cat <<EOF > /home/vault/alcide-policy.hcl
  path "secret/data/alcide/advisor" {
    capabilities = ["read", "list"]
  }
  EOF
  ```
  ```
  vault policy write alcide-advisor /home/vault/alcide-policy.hcl
  ```
  3. enable kubernetes authentication. service account name is "alcide-advisor" and namespace is "alcide"
  ```
  vault auth enable kubernetes
  ```
  ```
  vault write auth/kubernetes/config \
     token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
     kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
     kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  ```
  ```
  vault write auth/kubernetes/role/alcide-advisor \
     bound_service_account_names=alcide-advisor \
     bound_service_account_namespaces=alcide \
     policies=alcide-advisor \
     ttl=24h
  ```
  4. put a key/value entry in vault, with AWS credencials (and potentially other integrations).
  replace the s3KeyId and s3AwsSecretAccessKey with actual vlaues
  ```
  vault kv put secret/alcide/advisor \
      s3AwsAccessKeyId=someawskey \
      s3AwsSecretAccessKey=someawssecret \
      slackApiToken=xoxb-somekey \
      alcideApiKey=alcideapikey  \
      prometheusUsername=''   \
      prometheusPassword=''
  ```
  5. `exit`
---
### Alcide Advisor
  1. create a namespace (if not allready exists)
  ```
  kubectl create namespace alcide
  ```
  2. edit the cornjob chart. S3 bucket name with the appropriate one:
  > containers -> name: alcide-cli -> env -> name: S3_DESTINATION -> value
  3. edit the cornjob chart. set the cornjob schedule
