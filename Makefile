
.SECONDARY:
.SECONDEXPANSION:

VERSION ?= 1.0.0

.phony: help

get-deps: ##@Install Dependencies Linux
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 
	chmod 700 get_helm.sh 
	./get_helm.sh

K8S_DEPLOYMENT_FILES = deploy/k8s

lint-chart: ##@Test Lint Helm Chart
	helm lint deploy/charts/alcide-advisor-cronjob

gen-k8s-deploy-advisor-local-profile: ##@Build Generate k8s deployment files from the helm chart
	mkdir -p $(K8S_DEPLOYMENT_FILES)
	helm template  -n alcide-advisor appconfigscan deploy/charts/alcide-advisor-cronjob \
		--set vaultAgent.mode=none \
		--set alcide.advisorProfileFile=advisor-profiles/alcide-kubernetes-assessment.advisor \
		--set image.alcideAdvisor=alcide/advisor:stable   > $(K8S_DEPLOYMENT_FILES)/advisor-cronjob-local-profile.yaml


gen-k8s-deploy-advisor: ##@Build Generate k8s deployment files from the helm chart
	mkdir -p $(K8S_DEPLOYMENT_FILES)
	helm template  -n alcide-advisor kubecve deploy/charts/alcide-advisor-cronjob \
		--set vaultAgent.mode=none \
		--set image.alcideAdvisor=alcide/advisor:stable   > $(K8S_DEPLOYMENT_FILES)/advisor-cronjob.yaml

gen-k8s-deploy-advisor-with-vault: ##@Build Generate k8s deployment files from the helm chart for Vault
	mkdir -p $(K8S_DEPLOYMENT_FILES)
	helm template  -n alcide-advisor opseval deploy/charts/alcide-advisor-cronjob \
		--set vaultAgent.mode=vault \
		--set image.alcideAdvisor=alcidelabs/advisor:2.11.0-vault > $(K8S_DEPLOYMENT_FILES)/advisor-cronjob-vault.yaml

gen-k8s-deploy-advisor-with-vault-agent-inject: ##@Build Generate k8s deployment files from the helm chart for Vault with Agent Inject
	mkdir -p $(K8S_DEPLOYMENT_FILES)
	helm template  -n alcide-advisor blueprintscan deploy/charts/alcide-advisor-cronjob \
		--set vaultAgent.mode=agent-inject \
		--set image.alcideAdvisor=alcidelabs/advisor:2.11.0-vault  > $(K8S_DEPLOYMENT_FILES)/advisor-cronjob-vault-agent-inject.yaml


gen-k8s-deploy-all: lint-chart gen-k8s-deploy-advisor-local-profile gen-k8s-deploy-advisor gen-k8s-deploy-advisor-with-vault gen-k8s-deploy-advisor-with-vault-agent-inject ##@Build Generate k8s deployment files from the helm chart
    

HELP_FUN = \
         %help; \
         while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^(.+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/ }; \
         print "Usage: make [options] [target] ...\n\n"; \
     for (sort keys %help) { \
         print "$$_:\n"; \
         for (sort { $$a->[0] cmp $$b->[0] } @{$$help{$$_}}) { \
             $$sep = " " x (30 - length $$_->[0]); \
             print "  $$_->[0]$$sep$$_->[1]\n" ; \
         } print "\n"; }

help: ##@Misc Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)	

.DEFAULT_GOAL := help

USERID=$(shell id -u)	