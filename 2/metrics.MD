# 🚀 Throughput Metrics (Including Disk I/O)

| Layer      | Category           | Metric                                               | Description                                                        | Threshold                    | Severity | Alert Condition                          | User Impact                                                   |
|------------|--------------------|-------------------------------------------------------|--------------------------------------------------------------------|------------------------------|----------|------------------------------------------|----------------------------------------------------------------|
| Cluster    | Network Throughput | `cluster_network_receive_bytes_total`               | Total incoming traffic across the cluster                          | 2x baseline                  | Info     | Sustained for 5 minutes                  | Potential traffic spike or DDoS                               |
| Cluster    | Network Throughput | `cluster_network_transmit_bytes_total`              | Total outgoing traffic across the cluster                          | 2x baseline                  | Info     | Sustained for 5 minutes                  | May indicate egress load increase                             |
| Node       | Disk I/O           | `node_disk_read_bytes_total`                         | Total number of bytes read from disk on the node                   | >500MB/s                     | Warning  | Sustained 3 intervals                    | Disk contention, slow I/O operations                         |
| Node       | Disk I/O           | `node_disk_written_bytes_total`                      | Total number of bytes written to disk on the node                  | >500MB/s                     | Warning  | Sustained 3 intervals                    | High disk activity may affect workload performance           |
| Pod        | Network Throughput | `container_network_receive_bytes_total{pod=...}`     | Ingress network throughput per pod                                 | 2x baseline                  | Warning  | Sustained for 3 intervals                | May affect application responsiveness                        |
| Pod        | Network Throughput | `container_network_transmit_bytes_total{pod=...}`    | Egress network throughput per pod                                  | 2x baseline                  | Warning  | Sustained for 3 intervals                | Could indicate data exfiltration or load                     |
| Container  | Disk I/O           | `container_fs_reads_bytes_total`                     | Disk reads by individual container                                 | >200MB/min                   | Warning  | Exceeds threshold 3 times                | May indicate disk-heavy workload                             |
| Container  | Disk I/O           | `container_fs_writes_bytes_total`                    | Disk writes by individual container                                | >200MB/min                   | Warning  | Exceeds threshold 3 times                | Risk of storage pressure                                     |

---

## ℹ️ Explanation

**Throughput metrics** help quantify the volume of data being transferred or processed over time. These include network traffic (ingress/egress) and disk input/output (read/write). High throughput isn't inherently bad, but unexpected spikes or sustained high activity can point to:

- Misconfigured applications
- Data-intensive workloads
- Network bottlenecks or failures
- Disk saturation and slow performance

### Key Monitoring Drivers

- **Cluster-level** throughput gives a view of the entire environment’s load.
- **Node-level** I/O helps identify local saturation issues or noisy neighbors.
- **Pod and container-level** data provides visibility into specific workload behavior and anomalies.

Thresholds are set based on environment baselines or acceptable operating ranges. Alerts should trigger only after sustained anomalies to avoid false positives. Severity levels indicate the urgency and expected operational impact.

Let me know if you'd like this as a downloadable `.md` file or want to expand on any specific layer (e.g., ingress controller, tenants, etc.).
