# Kubernetes Kubelet Metrics with Severity Levels and Thresholds

This table lists key Kubernetes kubelet metrics by functional category, with suggested thresholds and alert severity to monitor node health, resource usage, and workload management.

---

## Kubelet Metrics Table (Sorted by Category and Severity)

| Category              | Metric                                           | Description                                         | Threshold            | Severity  | Alert Condition                    | User Impact                                        |
|-----------------------|------------------------------------------------|-----------------------------------------------------|----------------------|-----------|----------------------------------|----------------------------------------------------|
| Node Health           | `kubelet_runtime_operations_errors_total`      | Total errors from container runtime operations       | >0                   | Critical  | >0 for 1 interval                | Containers fail to start or stop, workload impact  |
| Node Health           | `kubelet_node_status_condition`                 | Node Ready condition reported by kubelet            | Not Ready             | Critical  | On state change                  | Node unavailable for scheduling, pod eviction      |
| Node Health           | `kubelet_heartbeat_failed`                       | Missed node heartbeats                                | >3 consecutive misses | Critical  | >=3 missed heartbeats            | Node may be unreachable, impacting workloads       |
| Resource Usage        | `kubelet_volume_stats_used_bytes`                | Disk space used by volumes                            | >90% capacity         | Warning   | >90% for 3 intervals             | Disk pressure may cause pod evictions               |
| Resource Usage        | `kubelet_volume_stats_capacity_bytes`            | Total disk space available for volumes                | Low capacity          | Warning   | Drop below threshold for 3 intervals | Risk of storage exhaustion                         |
| Resource Usage        | `kubelet_cpu_cfs_throttled_seconds_total`        | CPU throttling duration due to CFS quota              | >5% CPU time          | Warning   | >5% for 3 intervals              | CPU limits causing degraded pod performance         |
| Resource Usage        | `kubelet_memory_working_set_bytes`                | Memory working set size of kubelet process            | >500MB                | Warning   | >500MB sustained for 5 minutes   | Kubelet resource saturation, potential instability  |
| Pod Lifecycle         | `kubelet_pod_start_duration_seconds{quantile="0.99"}` | 99th percentile pod start time                         | >30s                  | Critical  | >30s for 3 intervals             | Slow pod startup impacting application availability |
| Pod Lifecycle         | `kubelet_pod_cpu_usage_seconds_total`             | CPU usage per pod                                     | Spike >2x baseline    | Warning   | Spike for 3 intervals            | Possible runaway pods or inefficient workloads       |
| Pod Lifecycle         | `kubelet_pod_eviction_count`                       | Number of pods evicted due to node pressure           | >0                    | Critical  | >0 for 1 interval                | Pods evicted impacting availability                  |
| Network & Connectivity| `kubelet_network_plugin_operations_errors_total` | Network plugin errors                                 | >0                    | Warning   | >0 for 1 interval                | Network misconfiguration or connectivity issues      |
| Network & Connectivity| `kubelet_runtime_operations_duration_seconds{operation="pod_network_setup"}` | Duration of pod network setup                          | >1s                   | Warning   | >1s for 3 intervals             | Delayed pod networking impacts readiness             |
| Volume & Storage      | `kubelet_volume_mount_duration_seconds`           | Time to mount volumes                                  | >1s                   | Warning   | >1s for 3 intervals             | Slow volume mounting delays pod startup               |
| Volume & Storage      | `kubelet_volume_mount_errors_total`                | Errors mounting volumes                                | >0                    | Critical  | >0 for 1 interval               | Pod startup failures due to volume issues             |
| System Health & Resources | `process_resident_memory_bytes`                    | Kubelet process memory usage                           | >500MB                 | Warning   | >500MB sustained for 5 minutes  | Possible memory leaks or resource exhaustion          |
| System Health & Resources | `process_cpu_seconds_total`                          | CPU time consumed by kubelet process                   | >80% core usage        | Warning   | >80% for 5 minutes             | Node pressure, degraded kubelet responsiveness        |
| System Health & Resources | `go_threads`                                         | Number of Go threads                                    | >500                   | Warning   | >500 sustained for 5 minutes   | Possible goroutine leaks                                |

---

## Explanation

- **Alert Condition:** The metric must breach its threshold for the specified number of consecutive evaluation intervals to avoid alert noise.
- **Severity:** Indicates the urgency and potential impact from Warning (early signs) to Critical (immediate issues).
- **User Impact:** Explains how each metric affects pod scheduling, node availability, and application reliability.

