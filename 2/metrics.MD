# NGINX Ingress Controller Metrics (Per Hostname)

This section outlines key metrics to monitor for the NGINX Ingress Controller in your Kubernetes cluster, including per-hostname breakdowns to help isolate issues by virtual host. Monitoring these metrics ensures availability, performance, and stability of ingress traffic.

| Category     | Metric                                               | Description                                           | Threshold                     | Severity  | Alert Condition                         | User Impact                                              |
|--------------|------------------------------------------------------|-------------------------------------------------------|-------------------------------|-----------|----------------------------------------|----------------------------------------------------------|
| Network Usage| `nginx_ingress_controller_requests{host="<hostname>"}` | Total HTTP requests handled by NGINX Ingress per hostname. Helps identify traffic spikes or DDoS attempts targeted at specific domains. | > baseline + 2x std dev        | Warning   | Spike over 3 consecutive intervals     | Possible burst traffic or DDoS impacting specific hostname availability.      |
| Network Usage| `nginx_ingress_controller_request_duration_seconds{host="<hostname>"}` | Request processing latency measured at the 95th percentile per hostname. High latency impacts user experience. | 95th percentile > 1s           | Warning   | Sustained over 2 consecutive intervals | Users accessing this hostname may experience slow page loads or timeouts.    |
| Availability| `nginx_ingress_controller_upstream_errors_total{host="<hostname>"}` | Number of errors connecting to backend services per hostname. Reflects backend availability issues or misconfiguration. | > 1% error rate                | Critical  | Exceeds threshold for 5 minutes        | Backend failures cause downtime or degraded functionality on affected host.  |
| Stability   | `nginx_ingress_controller_config_last_reload_successful` | Indicates whether the last ingress controller configuration reload was successful. A failed reload could mean configuration errors. | False                         | Critical  | On any failed reload                   | Misconfiguration could cause ingress outages or degraded service routing.    |
| Network Usage| `nginx_ingress_controller_connections_active`        | Number of active client connections handled by the ingress controller. High connection counts can indicate load spikes or leaks. | > expected max connections     | Warning   | Sustained over 3 consecutive intervals | Potential overload or connection management issues affecting ingress stability. |
| Availability| `nginx_ingress_controller_failure_rate{host="<hostname>"}` | Ratio of failed requests to total requests per hostname, indicating request failures or client errors impacting service quality. | > 5%                         | Critical  | Breach sustained over 5 minutes         | High error rates leading to poor user experience and possible SLA violations. |

---

### Explanation

- **Per Hostname Metrics:** Using the `host` label allows granular monitoring by virtual host or domain. This helps quickly pinpoint which services are experiencing issues without affecting the entire ingress.
- **Thresholds and Severity:** Thresholds are suggested starting points and should be tuned based on typical traffic patterns and SLA requirements. Critical severity implies immediate action needed.
- **Alert Conditions:** Alerts trigger after thresholds are met for multiple consecutive evaluation intervals, reducing noise from transient spikes.
- **User Impact:** Descriptions explain the end-user or service impact, aiding in prioritizing response and remediation efforts.

Monitoring these metrics closely helps maintain a healthy ingress layer, ensuring reliable and performant traffic routing to backend services.
