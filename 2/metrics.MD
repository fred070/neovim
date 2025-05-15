# Antrea CNI Metrics with Severity Levels and Thresholds

This table lists key Antrea CNI metrics, categorized by functionality and sorted by severity. These metrics are crucial for understanding networking health, performance, and security across Kubernetes clusters using Antrea.

---

## Antrea CNI Metrics Table (Sorted by Category and Severity)

| Category              | Metric                                                       | Description                                               | Threshold                  | Severity  | Alert Condition                  | User Impact                                              |
|-----------------------|---------------------------------------------------------------|-----------------------------------------------------------|----------------------------|-----------|----------------------------------|----------------------------------------------------------|
| Agent Health          | `antrea_agent_ovs_flow_ops_error_total`                      | Total OVS flow operation errors                            | >0                         | Critical  | >0 for 1 interval                | Network policies not applied or broken data plane        |
| Agent Health          | `antrea_agent_ovs_flow_ops_latency_seconds{quantile="0.99"}` | 99th percentile OVS operation latency                      | >0.5s                      | Warning   | >0.5s for 3 intervals            | Delayed network policy enforcement or route updates       |
| Agent Health          | `antrea_agent_runtime_info`                                   | Reports agent status and configuration                     | Missing or unhealthy       | Critical  | No report for 2 intervals        | CNI agent not responding, network connectivity degraded   |
| Controller Health     | `antrea_controller_runtime_info`                              | Reports controller status and configuration                | Missing or unhealthy       | Critical  | No report for 2 intervals        | Central policy/controller failure                         |
| Controller Performance| `antrea_controller_networkpolicy_duration_seconds{quantile="0.99"}` | 99th percentile policy processing latency            | >1s                        | Warning   | >1s for 3 intervals              | Delay in applying new network policies                    |
| Controller Performance| `antrea_controller_networkpolicy_total`                       | Number of active network policies managed                  | Sudden spike >2x baseline  | Warning   | Spike for 3 intervals            | Excess policy churn, possible instability                 |
| Flow Export           | `antrea_agent_flow_exporter_flows_exported_total`            | Total flows exported to external collector                 | Drop >50% from baseline    | Warning   | Drop sustained 3 intervals       | Missing flow logs, affecting audit/compliance             |
| Flow Export           | `antrea_agent_flow_collector_export_failures_total`          | Flow export delivery failures                              | >0                         | Warning   | >0 for 2 intervals               | Flows not reaching monitoring system                      |
| Resource Usage        | `process_resident_memory_bytes`                               | Antrea agent/controller memory usage                       | >500MB                     | Warning   | Sustained >500MB for 5 intervals | Risk of OOM or degraded performance                       |
| Resource Usage        | `process_cpu_seconds_total`                                   | CPU consumed by agent/controller                           | >80% core usage            | Warning   | >80% sustained for 5 intervals   | CPU pressure affecting performance                        |
| Network Packet Drops  | `antrea_agent_egress_dropped_packets_total`                  | Packets dropped by egress policies                         | Spike >3x baseline         | Warning   | Spike for 3 intervals            | Could indicate misconfigured or overly strict policies    |
| Network Policy        | `antrea_agent_connection_for_denied_flows_total`             | Total flows denied by network policies                     | Spike >2x baseline         | Warning   | Spike for 3 intervals            | Possible attack or misconfigured policy                   |
| Network Policy        | `antrea_agent_connection_for_allowed_flows_total`            | Total flows allowed by network policies                    | Drop >30% baseline         | Warning   | Drop for 3 intervals             | Connectivity loss or service routing issue                |
| System Health         | `go_threads`                                                  | Go threads used by Antrea components                       | >500                       | Warning   | >500 sustained for 5 intervals   | Potential goroutine leak or threading issues              |

---

## Explanation

- **Alert Condition**: Triggered when a metric crosses the threshold for a given number of intervals.
- **Severity**:
  - **Critical**: Immediate intervention required. Impacts core networking or connectivity.
  - **Warning**: Degradation detected. Should be triaged before escalation.
- **User Impact**: Describes how metric behavior could affect pod networking, traffic visibility, or policy enforcement.
