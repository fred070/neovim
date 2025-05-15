# Kubernetes Workload Metrics with Severity Levels and Thresholds

This table tracks Kubernetes workload metrics to assess health, availability, and performance of deployed applications. These metrics are vital for SRE, DevOps, and platform teams to ensure SLAs and reliability.

---

## Kubernetes Workload Metrics Table (Sorted by Category and Severity)

| Category             | Metric                                              | Description                                               | Threshold                     | Severity  | Alert Condition                      | User Impact                                                  |
|----------------------|------------------------------------------------------|-----------------------------------------------------------|-------------------------------|-----------|--------------------------------------|--------------------------------------------------------------|
| Pod Availability     | `kube_pod_status_phase{phase="Failed"}`             | Number of failed Pods                                      | >0                            | Critical  | >0 for 1 interval                    | Immediate app crash or failure                               |
| Pod Availability     | `kube_pod_status_ready{condition="true"}`           | Number of ready pods                                       | <desired replica count        | Critical  | Missing pods for 2 intervals         | Application not fully available                              |
| Deployment Health    | `kube_deployment_status_replicas_unavailable`       | Unavailable replicas in a deployment                       | >0                            | Critical  | >0 for 2 intervals                   | Service degradation or outage                                |
| Deployment Health    | `kube_deployment_spec_replicas`                     | Desired replica count                                      | Sudden drop >30%              | Warning   | Drop sustained for 3 intervals       | Possible misconfiguration or autoscaling issue               |
| ReplicaSet Health    | `kube_replicaset_status_ready_replicas`             | Ready replicas in a ReplicaSet                             | <desired replica count        | Critical  | Mismatch for 2 intervals             | App instances missing or restarting                          |
| Pod Lifecycle        | `kube_pod_container_status_terminated_reason`       | Termination reasons for containers                         | Frequent non-zero exits       | Warning   | Spike >3x baseline                   | Crashes due to config, resource, or code issue               |
| Pod Lifecycle        | `kube_pod_container_status_restarts_total`          | Restart count for containers                               | >5 restarts/hour              | Warning   | Sustained for 3 intervals            | Stability issues or crash loops                              |
| Scheduling           | `kube_pod_status_scheduled{condition="false"}`      | Unschedulable Pods                                         | >0                            | Critical  | >0 for 1 interval                    | Node pressure, taints, or resource exhaustion                |
| DaemonSet Health     | `kube_daemonset_status_number_unavailable`          | Unavailable Pods in a DaemonSet                            | >0                            | Warning   | >0 for 3 intervals                   | Logging/monitoring/infra agents missing                      |
| Resource Requests    | `kube_pod_container_resource_requests_cpu_cores`    | CPU requested by pods                                      | Sudden spike >50% baseline    | Warning   | Spike sustained for 3 intervals      | Risk of cluster CPU exhaustion                               |
| Resource Requests    | `kube_pod_container_resource_requests_memory_bytes` | Memory requested by pods                                   | Sudden spike >50% baseline    | Warning   | Spike sustained for 3 intervals      | Risk of memory saturation                                    |
| Job Failures         | `kube_job_status_failed`                            | Number of failed Job executions                            | >0                            | Warning   | >0 for 1 interval                    | Batch jobs not completing                                    |
| Job Completion       | `kube_job_status_succeeded`                         | Number of successful Job executions                        | Sudden drop to 0              | Warning   | Drop for 2 intervals                 | CronJobs or batch workflows stalling                         |
| Horizontal Scaling   | `kube_horizontalpodautoscaler_status_desired_replicas` | Desired replicas under autoscaler                     | Stuck at high/low for 5 min    | Warning   | No change over 3 intervals           | HPA misbehaving, possibly due to metric/config error         |
| Deployment Rollout   | `kube_deployment_status_observed_generation`        | Tracks deployment rollout completion                       | Lagging >2 behind generation  | Warning   | Mismatch for 3 intervals             | Rollouts not finishing or stuck                              |
| Init Containers      | `kube_pod_init_container_status_terminated_reason`  | Termination reasons for init containers                    | Frequent retries or errors    | Warning   | Spike >2x baseline                   | Init script/config failure delaying pod startup              |

---

## Explanation

- **Alert Condition**: Defines the rule for firing an alert, typically requiring breach over multiple evaluation intervals (to reduce false positives).
- **Severity**:
  - **Critical**: Direct availability or stability impact. Should trigger on-call.
  - **Warning**: Performance degradation, misconfiguration, or impending failures. Action needed but may not need immediate escalation.
- **User Impact**: Indicates how the metric degradation could affect end-users or the platform.

---

Let me know if you'd like dashboards or alert rules (e.g., Prometheus or Grafana) for these workload metrics.
