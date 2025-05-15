# Kubernetes Kube-Scheduler Metrics with Severity Levels and Thresholds

This table lists key Kubernetes kube-scheduler metrics by functional category, with suggested thresholds and alert severity to monitor cluster scheduling health and performance.

---

## Kube-Scheduler Metrics Table (Sorted by Category and Severity)

| Category              | Metric                                            | Description                                      | Threshold           | Severity  | Alert Condition                    | User Impact                                   |
|-----------------------|-------------------------------------------------|------------------------------------------------|---------------------|-----------|----------------------------------|-----------------------------------------------|
| Scheduling Performance | `scheduler_scheduling_duration_seconds{quantile="0.99"}` | 99th percentile scheduling latency (time to schedule pods) | >1s                 | Critical  | >1s for 3 consecutive intervals  | Pod scheduling delays, impacting app availability |
| Scheduling Performance | `scheduler_scheduling_attempts_total`            | Total scheduling attempts per second            | Spike >2x baseline  | Warning   | Spike for 3 intervals             | Unusual scheduling load, possible contention  |
| Scheduling Performance | `scheduler_e2e_scheduling_latency_seconds{quantile="0.99"}` | End-to-end scheduling latency (from pod creation to binding) | >5s                 | Critical  | >5s for 3 consecutive intervals  | Significant pod startup delays                  |
| Scheduling Queue       | `scheduler_queue_backlog`                         | Number of pods waiting in scheduling queue      | >100                | Warning   | >100 for 3 intervals              | Scheduling backlog leading to pod delays      |
| Scheduling Queue       | `scheduler_queue_pending_pods`                    | Number of pending pods in queue                  | >50                 | Warning   | >50 for 3 intervals               | High pending pods may impact rollout speed     |
| Scheduling Queue       | `scheduler_queue_unschedulable_pods`             | Pods marked unschedulable due to resource constraints | >10                 | Warning   | >10 for 3 intervals               | Resource pressure or scheduling issues         |
| Scheduling Errors      | `scheduler_binding_duration_seconds{quantile="0.99"}` | Time taken for binding pods to nodes             | >1s                 | Warning   | >1s for 3 intervals               | Binding delays impacting pod startup            |
| Scheduling Errors      | `scheduler_scheduling_errors_total`               | Total number of scheduling errors                 | >0                  | Critical  | >0 for 1 interval                | Pod scheduling failures, impacting workloads    |
| Scheduling Health      | `scheduler_cache_pods`                            | Number of pods in scheduler cache                 | Large sudden drop   | Warning   | Drop detected for 1 interval      | Scheduler cache inconsistency or sync issues    |
| Scheduling Health      | `scheduler_cache_nodes`                           | Number of nodes known to scheduler                | Drop >10%           | Warning   | Drop sustained for 2 intervals    | Node info inconsistency impacting scheduling    |
| Scheduling Health      | `scheduler_cache_pod_add_latency_seconds`         | Time to add pods to scheduler cache               | >0.1s               | Warning   | >0.1s for 3 intervals             | Cache update delays impacting scheduler state   |
| Resource Pressure      | `scheduler_predicate_evaluation_duration_seconds{quantile="0.99"}` | Time to evaluate scheduling predicates          | >0.5s               | Warning   | >0.5s for 3 intervals             | Predicate evaluation delays may slow scheduling |
| Resource Pressure      | `scheduler_preemption_attempts_total`              | Number of preemption attempts                       | Spike >2x baseline  | Warning   | Spike for 3 intervals             | Increased preemptions may indicate resource crunch |
| Resource Pressure      | `scheduler_framework_extension_point_duration_seconds` | Duration spent in scheduler framework plugins      | >0.5s               | Warning   | >0.5s for 3 intervals             | Scheduler plugin delays impacting scheduling    |
| System Health & Resources | `process_resident_memory_bytes`                    | Memory usage of scheduler process                   | >500MB              | Warning   | >500MB sustained for 5 minutes    | Resource saturation, possible OOM                |
| System Health & Resources | `process_cpu_seconds_total`                          | CPU time consumed by scheduler                      | >80% core usage     | Warning   | >80% for 5 minutes               | Node pressure, degraded scheduler responsiveness |
| System Health & Resources | `go_threads`                                         | Number of Go threads                                 | >500                | Warning   | >500 sustained for 5 minutes      | Possible goroutine leaks                         |

---

## Explanation

- **Alert Condition:** Metrics should breach threshold values for the specified consecutive evaluation intervals before triggering alerts to reduce noise.
- **Severity:** Levels indicate the criticality of the issue, from Warning to Critical.
- **User Impact:** Describes potential effects on pod scheduling, application availability, and cluster stability.

