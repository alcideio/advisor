# Customize Your Deployment Files

 
> Install Helm 3:
  ```bash
  make get-deps
  ```
> Edit Alcide Advisor [Helm Chart Value File](charts/cluster-job/values.yaml)
  * Default deployment
  * Default deployment with support for *Hashicorp Vault*
  * Default deployment with support for *Hashicorp Vault* **Agent Injector**

> Generate Kubernetes YAML file)s)
  ```bash
  make gen-k8s-deploy-all
  ```



# Alcide Advisor Vault integration Examples

this example runs Alcide advisor as a kubernetes cron job.
the results are exported to S3 bucket. with credentials supplied by HashiCorp vault, via vault-agent integration.

this example make use of Vault installed in cluster.

---
### Vault
* #### installation
  please follow the documentation on HashiCorp website
  - [vault-helm](https://github.com/hashicorp/vault-helm)
  - [vault initialization](https://www.vaultproject.io/docs/platform/k8s/helm/run)
* #### configuration
    Assumptions:
    > namespace -> alcide-advisor <br />
    > advisor serviceaccount name -> alcide-advisor <br />
    > vault installation namespace -> demo <br />

  1. `kubectl exec -ti vault-0 /bin/sh`
  2. create a policy
  ```
  #> cat <<EOF > /home/vault/alcide-policy.hcl
  path "secret/data/alcide/advisor" {
    capabilities = ["read"]
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
     bound_service_account_namespaces=alcide-advisor \
     policies=alcide-advisor \
     ttl=1h
  ```
  4. put a key/value entry in vault, with AWS credencials (and potentially other integrations). <br />
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
  1. create a namespace (if not already exists)
  ```
  kubectl create namespace alcide-advisor
  ```
  2. edit the cornjob chart. S3 bucket name with the appropriate one:
  > containers -> name: alcide-cli -> env -> name: S3_DESTINATION -> value
  3. edit the cornjob chart. set the cornjob schedule
