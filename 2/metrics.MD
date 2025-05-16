# ❗ Error Rate Metrics (Including Ingress Hostnames)

| Layer      | Category     | Metric                                                                                                      | Description                                                                     | Threshold                     | Severity | Alert Condition                          | User Impact                                                  |
|------------|--------------|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|-------------------------------|----------|------------------------------------------|---------------------------------------------------------------|
| Cluster    | API Errors   | `apiserver_request_errors_total`                                                                            | Total number of failed API server requests                                      | >5% of total requests         | Critical | >5% error rate over 5 mins                | API availability issues, degraded cluster functionality       |
| Cluster    | Scheduler    | `scheduler_schedule_attempts_failed_total`                                                                  | Failed pod scheduling attempts                                                  | >10 failures per min          | Warning  | Sustained for 3 intervals                 | Pods remain pending or unscheduled                           |
| Node       | Kubelet      | `kubelet_runtime_errors_total`                                                                              | Kubelet runtime errors (e.g. container start failures)                          | >0 in 5 minutes               | Warning  | Any increase in 5-minute window          | Pods may fail to start or restart frequently                 |
| Pod        | Application  | `http_requests_total{status=~"5..",pod=...}`                                                                | 5xx application-level HTTP errors                                               | >1% of total requests         | Warning  | Sustained for 3 intervals                 | Application degradation, bad user experience                 |
| Container  | App Errors   | `container_restart_count`                                                                                   | Restarts due to crash or failure                                                | >3 restarts in 5 mins         | Warning  | More than 3 restarts in 5 mins           | Unstable container or failing application                    |
| Ingress    | HTTP Errors  | `nginx_ingress_controller_requests{status=~"5..",host="example.com"}`                                       | 5xx errors served by ingress controller per hostname                            | >2% of total requests         | Warning  | Sustained for 5 mins                     | Application unavailable or backend failure for that domain   |
| Ingress    | Error Ratio  | `rate(nginx_ingress_controller_requests{status=~"5..",host="example.com"}[5m]) / rate(nginx_ingress_controller_requests{host="example.com"}[5m])` | Failure ratio per hostname | >0.02 (2%)                     | Warning  | Breach over 2 consecutive windows         | Ingress traffic is failing for specific route/domain         |

---

## ℹ️ Explanations

### What are Error Rate Metrics?
Error rate metrics quantify how often operations fail, whether at the cluster level (e.g., failed API calls), workload level (e.g., pod restarts), or application level (e.g., HTTP 5xx responses).

### Why They're Important:
High error rates often indicate degraded service, broken dependencies, misconfigurations, or failing components. Monitoring and alerting on error rates is critical for:

- Ensuring high availability
- Rapid failure detection
- Maintaining SLAs/SLOs
- Prioritizing recovery efforts

### Why Include Hostname in Ingress Metrics?
In environments using Ingress (e.g., NGINX Ingress Controller), traffic may be routed based on hostname (e.g., `app.tenant-a.com`). Monitoring per-hostname error rates enables:

- Isolation of issues affecting specific domains or tenants
- Better troubleshooting of multi-tenant environments
- Detection of failing deployments or misrouted traffic

### Severity and Impact
Severity is based on threshold breaches and scope of impact:

- **Critical**: Affects major functionality or a large part of the cluster (e.g., API failures).
- **Warning**: Localized or temporary issues (e.g., pod restart spikes, ingress errors).
- **Alert Conditions** ensure that metrics are evaluated over sustained intervals to reduce false positives.

Let me know if you'd like this integrated into your full observability documentation or exported to a file.
