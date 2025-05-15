# Kubernetes Kube-Proxy Metrics with Severity Levels and Thresholds

This table lists key Kubernetes kube-proxy metrics by functional category, with suggested thresholds and alert severity to monitor network proxy health, performance, and stability at the node level.

---

## Kube-Proxy Metrics Table (Sorted by Category and Severity)

| Category              | Metric                                            | Description                                         | Threshold            | Severity  | Alert Condition                    | User Impact                                        |
|-----------------------|--------------------------------------------------|-----------------------------------------------------|----------------------|-----------|----------------------------------|----------------------------------------------------|
| Network Connectivity  | `kubeproxy_sync_proxy_rules_error_total`          | Total errors syncing proxy rules                      | >0                   | Critical  | >0 for 1 interval                | Network rules not applied, causing service disruption |
| Network Connectivity  | `kubeproxy_sync_proxy_rules_duration_seconds{quantile="0.99"}` | 99th percentile time to sync proxy rules             | >1s                   | Warning   | >1s for 3 consecutive intervals  | Delayed rule updates can cause stale routing         |
| Network Packet Drops  | `kubeproxy_iptables_packet_drops_total`            | Total iptables packet drops                           | >100 per minute       | Critical  | >100 drops/min for 2 intervals    | Network packets dropped, impacting traffic flow       |
| Network Packet Drops  | `kubeproxy_ipvs_sync_failures_total`                | Failures in syncing IPVS rules                        | >0                    | Critical  | >0 for 1 interval                | IPVS rules not applied, causing routing issues        |
| Resource Usage        | `process_resident_memory_bytes`                      | Memory usage of kube-proxy process                   | >500MB                | Warning   | >500MB sustained for 5 minutes   | Possible memory leaks or resource exhaustion          |
| Resource Usage        | `process_cpu_seconds_total`                           | CPU time consumed by kube-proxy process              | >80% core usage       | Warning   | >80% for 5 minutes               | High CPU usage affecting node network performance     |
| Network Errors       | `kubeproxy_sync_proxy_rules_error_total`            | Errors during proxy rule synchronization              | >0                    | Critical  | >0 for 1 interval                | Proxy rules failing, causing service disruption       |
| Sync Operations      | `kubeproxy_sync_proxy_rules_total`                   | Total proxy sync operations                           | Spike >2x baseline    | Warning   | Spike for 3 intervals            | Increased syncs may indicate instability or churn     |
| Network Connections  | `kubeproxy_ipvs_connections_total`                   | Number of active IPVS connections                     | Drop >30%             | Warning   | Drop sustained for 3 intervals    | Loss of active connections, impacting network throughput |
| Network Latency      | `kubeproxy_ipvs_sync_duration_seconds{quantile="0.99"}` | 99th percentile duration of IPVS sync                 | >1s                   | Warning   | >1s for 3 intervals             | Slow IPVS sync affecting load balancing updates        |
| Network Flows        | `kubeproxy_iptables_flows_total`                      | Total iptables flow entries                            | Sudden drop           | Warning   | Sudden drop detected             | Possible network misconfiguration or data plane issues |

---

## Explanation

- **Alert Condition:** Metric breaches the threshold for the specified number of consecutive evaluation intervals to minimize false alerts.
- **Severity:** Ranges from Warning (potential issues) to Critical (immediate attention required).
- **User Impact:** Describes how metrics affect node network routing, service availability, and traffic handling.
