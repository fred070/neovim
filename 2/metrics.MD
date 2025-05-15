# Kubernetes etcd Metrics with Severity Levels and Thresholds

This document summarizes key etcd metrics, categorized by functional areas such as capacity, performance, health, security, and usage, along with suggested alert thresholds, severity levels, alert conditions, and user impact.

---

## etcd Metrics Table (Sorted by Category and Severity)

| Category    | Metric                                    | Description                                     | Threshold          | Severity  | Alert Condition                   | User Impact                                     |
|-------------|-------------------------------------------|------------------------------------------------|--------------------|-----------|---------------------------------|-------------------------------------------------|
| Capacity    | `etcd_disk_wal_fsync_duration_seconds`    | Time taken to fsync WAL writes                   | >0.1s              | Critical  | >0.1s for 3 consecutive intervals| Disk I/O bottleneck, risking data loss          |
| Capacity    | `etcd_disk_backend_commit_duration_seconds` | Backend commit latency                           | >0.2s              | Critical  | >0.2s for 3 consecutive intervals| Slow disk writes, impacting etcd performance    |
| Performance| `etcd_network_client_grpc_received_bytes_total` | Total bytes received over gRPC                   | Spike >2x baseline | Warning   | Spike lasting >5 minutes          | Network congestion impacting etcd traffic       |
| Performance| `etcd_network_client_grpc_sent_bytes_total`     | Total bytes sent over gRPC                        | Spike >2x baseline | Warning   | Spike lasting >5 minutes          | Network congestion impacting etcd traffic       |
| Performance| `etcd_server_proposals_committed_total`           | Number of proposals committed                     | Sudden drop        | Critical  | Sudden drop for 2 intervals       | Cluster writes failing, risking data consistency|
| Performance| `etcd_server_proposals_failed_total`               | Number of failed proposals                        | >0 for 5 minutes   | Critical  | >0 for 5 minutes                  | Write failures, risking cluster stability       |
| Performance| `etcd_server_leader_changes_seen_total`            | Number of leader elections                        | >3 in 5 min        | Critical  | >3 leader changes in 5 minutes    | Leader instability causing cluster disruption   |
| Health      | `etcd_server_has_leader`                            | Indicates if etcd has a leader (1=leader exists) | 0 (no leader)      | Critical  | 0 for 2 consecutive intervals     | Cluster not functional without leader           |
| Health      | `etcd_server_is_learner`                            | Is the node a learner                             | 1 (true)           | Warning   | Learner status persists >10 mins | Node not fully participating in quorum           |
| Health      | `etcd_mvcc_db_total_size_in_bytes`                  | Size of etcd database                             | Growth >20% in 1 hr| Warning   | Rapid growth triggers alert       | Potential storage bloat, disk pressure           |
| Health      | `etcd_mvcc_snap_save_total_duration_seconds`        | Snapshot save duration                            | >10s               | Warning   | >10s for 2 intervals              | Slow snapshots, risking backups                  |
| Security    | `etcd_server_failed_auth_requests_total`            | Failed authentication requests                    | >0                 | Warning   | Any failure                      | Unauthorized access attempts                      |
| Security    | `etcd_grpc_authenticate_requests_failed_total`      | gRPC authentication failures                      | >0                 | Warning   | Any failure                      | Authentication issues on gRPC                     |
| Usage       | `etcd_debugging_mvcc_db_compaction_pause_duration_seconds` | Duration of compaction pauses                    | >2s                | Warning   | >2s for 2 intervals               | Cluster slowdown during compactions               |
| Usage       | `etcd_network_client_grpc_closed_streams_total`      | Number of closed gRPC streams                      | Spike >10/min       | Warning   | Spike lasting >5 minutes          | Client connection instability                      |

---

## Explanation of Key Metrics

- **Disk WAL & Backend Commit Duration:**  
  Measures disk I/O latency on WAL writes and backend commits. High latency indicates storage bottlenecks risking data durability.

- **Network Client Traffic (gRPC bytes sent/received):**  
  Tracks network throughput of etcd clients. Sudden spikes may suggest increased load or network issues.

- **Proposals Committed/Failed:**  
  Reflects the number of successful and failed write proposals to the etcd cluster. Failures impact cluster consistency and availability.

- **Leader Changes & Leader Presence:**  
  Tracks leadership stability. Frequent leader changes or absence of a leader cause cluster disruptions.

- **Learner Status:**  
  Identifies nodes not fully participating in consensus, potentially reducing cluster reliability.

- **Database Size & Snapshots:**  
  Indicates data size growth and snapshot performance. Rapid growth or slow snapshots can degrade cluster performance.

- **Authentication Failures:**  
  Monitors security-related failed auth attempts, indicating potential attacks or misconfigurations.

- **Compaction Pause Duration:**  
  Time spent pausing during MVCC compactions, which may temporarily degrade performance.

- **Closed gRPC Streams:**  
  Frequent closed streams could indicate network instability or client issues.
