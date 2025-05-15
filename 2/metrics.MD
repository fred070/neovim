## Kubernetes API Server Metrics with Severity Levels and Thresholds

This table categorizes key Kubernetes API server metrics by functional area, and provides suggested thresholds and severity levels for alerting.

### Capacity & Request Volume

| Metric                                                      | Description                             | Threshold     | Severity | User Impact                                            |
| ----------------------------------------------------------- | --------------------------------------- | ------------- | -------- | ------------------------------------------------------ |
| `apiserver_request_total`                                   | Total API requests per second           | >1000 req/sec | Warning  | Potential API load surge, may lead to degraded latency |
| `apiserver_current_inflight_requests{request_kind="write"}` | Concurrent in-flight write requests     | >50           | Critical | Write latency or throttling, possible 429s             |
| `apiserver_current_inflight_requests{request_kind="read"}`  | Concurrent in-flight read requests      | >150          | Warning  | Read latency under burst load                          |
| `apiserver_longrunning_gauge`                               | Number of ongoing long-running requests | >50 sustained | Warning  | Resource pressure from watch/log sessions              |
| `apiserver_registered_watchers`                             | Active registered watchers              | >300          | Warning  | High memory/CPU usage, potential overload              |

### Performance & Latency

| Metric                                                | Description                          | Threshold | Severity | User Impact                                  |
| ----------------------------------------------------- | ------------------------------------ | --------- | -------- | -------------------------------------------- |
| `apiserver_request_duration_seconds{quantile="0.95"}` | 95th percentile API latency          | >1s       | Critical | Users see API timeouts or retries            |
| `apiserver_response_sizes_bucket`                     | Distribution of API response sizes   | >10% >1MB | Warning  | Large responses could slow clients           |
| `apiserver_dropped_requests_total`                    | Dropped API requests due to overload | >0        | Critical | API calls dropped or denied                  |
| `apiserver_request_terminations_total`                | Requests terminated by the server    | >0        | Warning  | Possible client disconnects or node pressure |

### Authentication & Authorization

| Metric                                                       | Description                        | Threshold     | Severity | User Impact                             |
| ------------------------------------------------------------ | ---------------------------------- | ------------- | -------- | --------------------------------------- |
| `apiserver_authentication_attempts_total{result="failure"}`  | Failed authentication attempts     | >1% fail rate | Warning  | Invalid credentials, login issues       |
| `apiserver_authorization_attempts_total{result="failure"}`   | Failed authorization requests      | >5% fail rate | Warning  | Permissions denied unexpectedly         |
| `apiserver_authentication_duration_seconds{quantile="0.99"}` | 99th percentile auth time          | >0.5s         | Warning  | Slower login and client requests        |
| `apiserver_authorization_duration_seconds{quantile="0.99"}`  | 99th percentile RBAC decision time | >0.5s         | Warning  | Slower response on RBAC-evaluated calls |

### Etcd & Storage Backend

| Metric                                                | Description                   | Threshold          | Severity | User Impact                                  |
| ----------------------------------------------------- | ----------------------------- | ------------------ | -------- | -------------------------------------------- |
| `apiserver_storage_duration_seconds{quantile="0.99"}` | Storage backend response time | >1.5s              | Critical | API calls time out or fail                   |
| `apiserver_storage_transformation_duration_seconds`   | Encryption/decryption delay   | >0.5s              | Warning  | Latency increase for sensitive resources     |
| `etcd_request_duration_seconds{quantile="0.99"}`      | Etcd backend latency          | >1.0s              | Critical | Slowness on persistent resource updates      |
| `apiserver_storage_objects`                           | Number of objects in storage  | Growth >10% in 1hr | Warning  | Possible storage bloat or runaway controller |

### Watches & Event Distribution

| Metric                                              | Description                    | Threshold    | Severity | User Impact                                  |
| --------------------------------------------------- | ------------------------------ | ------------ | -------- | -------------------------------------------- |
| `apiserver_watch_events_total`                      | Events dispatched to watchers  | >2x baseline | Warning  | Resource pressure, event lag                 |
| `apiserver_watch_cache_capacity_in_use / capacity`  | Watch cache utilization        | >85%         | Warning  | Risk of cache eviction, degraded performance |
| `apiserver_watch_duration_seconds{quantile="0.99"}` | 99th percentile watch duration | >1h          | Warning  | Persistent watchers may be leaking           |

### System Health & Resources

| Metric                          | Description                | Threshold       | Severity | User Impact                         |
| ------------------------------- | -------------------------- | --------------- | -------- | ----------------------------------- |
| `process_resident_memory_bytes` | Memory usage of API server | >1.5GB          | Warning  | Resource saturation, potential OOM  |
| `process_cpu_seconds_total`     | CPU time consumed          | >80% core usage | Warning  | Node pressure, degraded performance |
| `go_threads`                    | Number of Go threads       | >1000           | Warning  | Possible goroutine leaks            |

### Security Events

| Metric                                                   | Description               | Threshold        | Severity | User Impact                                  |
| -------------------------------------------------------- | ------------------------- | ---------------- | -------- | -------------------------------------------- |
| `apiserver_audit_event_total`                            | Audit events recorded     | Spike >3x normal | Warning  | Possible config change or attack vector      |
| `apiserver_envelope_encryption_dek_cache_misses_total`   | Missed cached DEK fetches | >10 misses/min   | Warning  | Extra latency for encrypted resources        |
| `apiserver_envelope_encryption_key_fetch_failures_total` | Key retrieval failures    | >0               | Critical | Encryption failures, possible data loss risk |
| `apiserver_tls_handshake_errors_total`                   | TLS handshake failures    | >0               | Warning  | Misconfigured clients or expired certs       |

### Usage Patterns & Access

| Metric                                   | Description            | Threshold     | Severity           | User Impact                         |
| ---------------------------------------- | ---------------------- | ------------- | ------------------ | ----------------------------------- |
| `apiserver_request_total{verb="WATCH"}`  | Volume of WATCH calls  | >2x baseline  | Warning            | Client overuse or watch abuse       |
| `apiserver_request_total{verb="LIST"}`   | Volume of LIST calls   | >2x baseline  | Warning            | Heavy dashboard use or lister loops |
| `apiserver_request_total{verb="PATCH"}`  | Volume of PATCH calls  | >50% increase | Warning            | Controllers over-patching objects   |
| `apiserver_request_total{verb="DELETE"}` | Volume of DELETE calls | >200% normal  | Warning / Critical | Risk of mass deletion or DoS        |
