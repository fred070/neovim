# Kubernetes Controller Manager Metrics with Severity Levels and Thresholds

This document summarizes critical Controller Manager metrics, categorized by functional areas such as capacity, performance, health, security, and usage, along with suggested alert thresholds, severity levels, alert conditions, and user impact.

---

## Controller Manager Metrics Table (Sorted by Category and Severity)

| Category   | Metric                                              | Description                                    | Threshold        | Severity  | Alert Condition                   | User Impact                                     |
|------------|-----------------------------------------------------|------------------------------------------------|------------------|-----------|---------------------------------|-------------------------------------------------|
| Capacity   | `controller_manager_workqueue_length`               | Number of items pending in controller queues  | >50              | Warning   | >50 for 2 consecutive intervals | Controllers backlog, delayed reconciliation     |
| Capacity   | `controller_manager_workqueue_depth`                | Depth of the controller workqueue              | >100             | Critical  | >100 for 2 consecutive intervals| Severe backlog, risk of stale cluster state      |
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

- **Workqueue Length & Depth:**  
  These metrics track the number of tasks pending and the depth of the internal controller queues. Elevated values indicate that controllers are falling behind processing cluster events, which may cause delays in reconciling resources and stale cluster state.

- **Workqueue Latency:**  
  Measures the time taken to process items from the controller manager’s workqueue. High latency suggests slow reconciliation loops and can result in delayed resource updates or inconsistent cluster state.

- **Reconcile Errors:**  
  The number of errors encountered during reconciliation attempts. A high or sustained error rate means controllers are failing to manage resources correctly, possibly impacting workloads.

- **Reconcile Duration:**  
  The time taken to complete controller reconcile loops. Longer durations can lead to slower cluster responsiveness.

- **Resource Usage (CPU/Memory):**  
  Tracks controller manager's memory and CPU consumption. Excessive resource use may lead to instability, slow performance, or crashes.

- **Go Goroutines:**  
  Number of active goroutines (lightweight threads). Excessive counts may indicate goroutine leaks, causing resource exhaustion.

- **TLS Handshake, Authentication, and Authorization Errors:**  
  Failures in secure communication and authentication indicate potential security misconfigurations or attacks.

- **Leader Elections:**  
  The controller manager uses leader election to ensure high availability. Failures here may cause multiple active controllers or downtime, leading to cluster management instability.

---

Let me know if you'd like this extended with example Prometheus alert rules or integration with specific monitoring tools!
