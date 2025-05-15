# Kubernetes Controller Manager Metrics with Severity Levels and Thresholds

This document summarizes critical Controller Manager metrics, categorized by functional areas such as capacity, performance, health, security, and usage, along with suggested alert thresholds, severity levels, alert conditions, and user impact.

---

## Controller Manager Metrics Table (Sorted by Category and Severity)

| Category   | Metric                                              | Description                                    | Threshold        | Severity  | Alert Condition                   | User Impact                                     |
|------------|-----------------------------------------------------|------------------------------------------------|------------------|-----------|---------------------------------|-------------------------------------------------|
| Capacity   | `controller_manager_workqueue_depth`                | Depth of the controller workqueue              | >100             | Critical  | >100 for 2 consecutive intervals| Severe backlog, risk of stale cluster state      |
| Capacity   | `controller_manager_workqueue_length`               | Number of items pending in controller queues  | >50              | Warning   | >50 for 2 consecutive intervals | Controllers backlog, delayed reconciliation     |
| Performance| `controller_manager_workqueue_latency_seconds`      | Time to process workqueue items (95th percentile) | >5s            | Critical  | >5s sustained over 3 intervals  | Slow reconciliation, delayed resource updates   |
| Performance| `controller_manager_reconcile_errors_total`         | Total reconcile errors count                    | >5 errors/min     | Warning   | >5 errors per minute             | Resource reconciliation failures                 |
| Performance| `controller_manager_reconcile_duration_seconds`     | Duration of reconcile loops                      | >10s             | Warning   | >10s for 3 consecutive intervals | Slow controller processing                        |
| Health     | `process_resident_memory_bytes`                      | Memory used by controller manager process       | >1.2GB           | Warning   | >1.2GB for 5 minutes             | Resource exhaustion, potential OOM                |
| Health     | `process_cpu_seconds_total`                           | CPU usage of controller manager                  | >80% core usage  | Warning   | >80% sustained for 5 minutes    | Node pressure, degraded controller performance   |
| Health     | `go_goroutines`                                       | Number of goroutines                              | >800             | Warning   | >800 for 5 minutes               | Potential goroutine leaks                          |
| Security   | `controller_manager_tls_handshake_errors_total`      | TLS handshake failures                            | >0               | Warning   | Any failure                     | Misconfigured clients or cert issues              |
| Security   | `controller_manager_authentication_errors_total`     | Authentication failures on controller manager    | >0               | Warning   | Any failure                     | Authentication problems, degraded communication  |
| Security   | `controller_manager_authorization_errors_total`      | Authorization failures                            | >0               | Warning   | Any failure                     | RBAC misconfigurations                             |
| Usage      | `controller_manager_leader_elections_failed_total`   | Leader election failures                          | >0               | Critical  | Any failure                    | Controller Manager instability                     |
| Usage      | `controller_manager_leader_elections_succeeded_total`| Successful leader elections                        | N/A              | Info      | N/A                            | Operational normality                              |

---

## Explanation of Key Metrics

- **Workqueue Depth & Length:**  
  These metrics track the depth and number of tasks pending in controller queues. High values indicate that the controllers are overwhelmed and unable to keep up with cluster changes, leading to stale or delayed state reconciliation.
- **Workqueue Latency:**  
  Time taken to process workqueue items. High latency affects cluster responsiveness and resource consistency.
- **Reconcile Errors:**  
  Indicates failed attempts to reconcile cluster resources. A high rate suggests controllers are struggling to maintain desired state.
- **Reconcile Duration:**  
  The time each reconciliation loop takes. Longer durations indicate potential performance issues.
- **Resource Usage (CPU/Memory):**  
  Measures resource consumption of the controller manager. Excessive usage can lead to degraded performance or crashes.
- **Go Goroutines:**  
  Tracks the number of active goroutines. An unusually high count may reveal resource leaks.
- **TLS Handshake, Authentication, Authorization Errors:**  
  Failures here indicate possible security issues or misconfiguration, impacting secure communications.
- **Leader Elections:**  
  Ensures only one active controller manager instance. Failures may result in controller instability or failover issues.

---

Let me know if you'd like me to add Prometheus alerting examples or extend monitoring recommendations!
