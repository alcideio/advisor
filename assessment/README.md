# Alcide Kubernetes Advisor - Self Assessment

![Alcide Advisor](https://codelab.alcide.io/images/card-frontpage/frontpage-alcide-advisor.png "Alcide Advisor")

Alcide Advisor is an agentless service for Kubernetes audit and compliance that’s built to ensure a frictionless and secured DevSecOps workflow by layering a hygiene scan of Kubernetes cluster & workloads early in the development process and before moving to production.

With Alcide Advisor, you can cover the following security checks:

- Kubernetes infrastructure vulnerability scanning.
- Hunting misplaced secrets, or excessive priviliges for secret access.
- Workload hardening from Pod Security to network policies.
- Istio security configuration and best practices.
- Ingress Controllers for security best practices.
- Kubernetes API server access privileges.
- Kubernetes operators security best practices.
- Deployment conformance to labeling, annotating, resource limits and much more ...

# Running Kubernetes Self Assessment

Make sure the Scan Token Your received from Alcide is available.

1.  ### ***Download Alcide Advisor Scanner***

*For Linux*

```bash
curl -o advisor https://alcide.blob.core.windows.net/generic/stable/linux/advisor && chmod +x advisor
```

*For Mac*

```bash
curl -o advisor https://alcide.blob.core.windows.net/generic/stable/darwin/advisor && chmod +x advisor
```

2. ### ***Download Alcide Advisor Assessment Profile***

```bash
curl -o scan.profile https://raw.githubusercontent.com/alcideio/advisor/master/assessment/alcide-kubernetes-assessment.advisor
```

3. ### ***Scan Your Cluster***

```bash
./advisor validate cluster --outfile alcide-advisor.html --policy-profile scan.profile --alcide-api-key <Your_Alcide_Scan_Token>
```


### **Review the assessment findings in your broweser** - open *alcide-advisor.html*


## Create Alcide Advisor Account

To get a tailor made exprience with **Alcide Kubernetes Advisor** start your risk-free [trial now](https://www.alcide.io/advisor-free-trial/)

![Alcide Kubernetes Advisor](https://d2908q01vomqb2.cloudfront.net/77de68daecd823babbb58edb1c8e14d7106e83bb/2019/06/19/Alcide-Advisor-Amazon-EKS-1.png "Alcide Kubernetes Advisor")


### Feedback and issues

If you have feedback or issues, submit a github issue
