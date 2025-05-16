# Latency Metrics Overview

Latency metrics measure the time delays in processing requests or operations. Monitoring latency is critical for understanding application responsiveness and user experience.

| Category         | Metric                                          | Description                                           | Threshold                    | Severity  | Alert Condition                         | User Impact                                                |
|------------------|-------------------------------------------------|-------------------------------------------------------|------------------------------|-----------|----------------------------------------|------------------------------------------------------------|
| API Server       | `apiserver_request_duration_seconds`            | Histogram of request latencies for Kubernetes API calls, broken down by verb and resource. | 95th percentile > 1s          | Warning   | Sustained over 2 consecutive intervals | API clients may experience slow responses, affecting controllers and kubectl commands. |
| API Server       | `apiserver_longrunning_gauge`                    | Number of long-running requests currently in flight.  | > 10                         | Warning   | Sustained for 3 intervals              | Backend slowdowns causing delayed API responses.           |
| Controller Manager | `controller_manager_queue_duration_seconds`    | Time items spend in controller queue before processing.| 95th percentile > 2s          | Warning   | Sustained over 3 intervals             | Delayed controller reconciliation affecting resource state.|
| Scheduler        | `scheduler_schedule_attempt_duration_seconds`   | Time taken by the scheduler to attempt scheduling a pod.| 95th percentile > 1s          | Warning   | Sustained over 2 intervals             | Scheduling delays causing pod startup latency.             |
| Ingress / Proxy  | `nginx_ingress_controller_request_duration_seconds` | Request processing latency in the NGINX ingress controller. | 95th percentile > 1s          | Warning   | Sustained over 2 intervals             | Slow page loads impacting end-user experience.             |
| Node (Kubelet)   | `kubelet_runtime_operations_duration_seconds`   | Latency of container runtime operations (e.g., start, stop). | 95th percentile > 1s          | Warning   | Sustained over 2 intervals             | Delayed container lifecycle events impacting workload readiness. |
| Pod / Container  | Custom application latency metrics (e.g., HTTP request duration) | Application-specific request or processing latency measured via instrumentation. | Depends on SLA                | Warning   | Sustained degradation                  | End users experience slow application response times.      |

---

### Notes:

- **Percentile Metrics:** Using 95th percentile or higher captures tail latency, which affects user experience more than average latency.
- **Sustained Thresholds:** Alert conditions require the latency to be above threshold for multiple consecutive evaluation intervals to avoid false positives.
- **Latency Context:** Latency impacts both system components (e.g., API server) and end-user experience (e.g., ingress latency, application latency).
- **Custom Metrics:** Instrumenting your applications with latency metrics is highly recommended for full observability.

Monitoring latency across these layers helps quickly detect performance regressions and bottlenecks in your Kubernetes environment.
