## Alcide Kubernetes Advisor Integration | Prometheus + Grafana

Alcide Kubernetes Advisor in-cluster periodic scanner expose the latest scan summary as grafana dashboard over prometheus datasource.

![Alcide Kubernetes Advisor Grafana Dashboard](alcide-advisor-grafana-example.png "Alcide Kubernetes Advisor Grafana Dashboard")

### Create an Account

Get **Alcide Kubernetes Advisor** with a risk-free account. [signup here](https://www.alcide.io/advisor-free-trial/)

### Installation

The file `alcide-servicemonitor.yaml` will deploy  `Service` of type `ClusterIp` and Prometheus Operator `ServiceMonitor`. 
The service basically serve as the scraping endpoint for prometheus Service Monitors.

The file `alcide-servicemonitor.yaml` is based on the default Prometheus Operator installation into `monitoring` namespace. If you deployed into a different namespace, make sure to make the necessary edits.

- `kubectl apply -f alcide-servicemonitor.yaml`
- Login into your Grafana and add the dashboard `alcide-advisor-grafana.json`

## Troubleshooting

If you run into issues please see Prometheus Operator [Service Monitor troubleshooting section](https://github.com/coreos/prometheus-operator/blob/master/Documentation/troubleshooting.md#overview-of-servicemonitor-tagging-and-related-elements)



