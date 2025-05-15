# 📊 Kubernetes API Server Metrics – Categories, Thresholds, and Alerts

## 🧠 Capacity & Request Volume

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `apiserver_request_total` | >1000 requests/sec per API server | Possible overload | High sustained volume | 5 min rate |
| `apiserver_current_inflight_requests` | >150 read, >50 write | API latency or 429s | Read >150 or Write >50 | ≥2 consecutive intervals |
| `apiserver_longrunning_gauge` | >10 long-running requests | Slower watch/list responses | Gauge value >10 | Sustained 5 minutes |
| `apiserver_registered_watchers` | Spike >300 in 5 min | Memory pressure | Increase >300 | 5 min delta |

## ⚡ Performance & Latency

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `apiserver_request_duration_seconds{quantile="0.95"}` | >1.0s | User-facing slowness | P95 >1.0s | 5 of 6 points (5-min) |
| `apiserver_response_sizes_bucket` | >10% >1MB | Serialization/bloat | >10% responses >1MB | Over 10 min |
| `apiserver_dropped_requests_total` | >0 | Throttling | Any increase | Δ > 0 over 5 min |
| `apiserver_request_terminations_total` | >0 | Client disconnects | Any increment | Δ > 0 over 5 min |

## 🔐 Authentication & Authorization

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `apiserver_authentication_attempts_total{result="failure"}` | >1% failures | 401s / access denial | Failure rate >1% | 10 min average |
| `apiserver_authorization_attempts_total{result="failure"}` | >5% failures | 403s / RBAC errors | Failure rate >5% | 10 min window |
| `apiserver_authentication_duration_seconds{quantile="0.99"}` | >0.5s | Login/API delay | P99 >0.5s | 5 min window |
| `apiserver_authorization_duration_seconds{quantile="0.99"}` | >0.5s | Rule eval slowness | P99 >0.5s | 5 min window |

## 💾 Etcd & Storage Backend

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `apiserver_storage_duration_seconds{quantile="0.99"}` | >1.5s | API timeout risk | P99 >1.5s | 5 min window |
| `apiserver_storage_transformation_duration_seconds` | >0.5s | Encrypted access delay | >0.5s consistently | 5 min window |
| `etcd_request_duration_seconds{quantile="0.99"}` | >1.0s | Etcd bottleneck | P99 >1.0s | 5 min window |
| `apiserver_storage_objects` | Growth >10% in 1h | Resource scaling issues | Sudden growth trend | Hourly delta |

## 📡 Watches & Events

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `apiserver_watch_events_total` | Rate spike >2x | API/client pressure | Sudden spike | Over 10 min |
| `apiserver_watch_cache_capacity_in_use / capacity` | >0.85 | Evictions, stale reads | Utilization >85% | 3 of 5 checks |
| `apiserver_watch_duration_seconds{quantile="0.99"}` | >1h | Lingering or stale watches | Watch duration >1h | Continuous 15m |

## 🧰 System Health & Resources

| Metric | Threshold | User Impact | Alert Condition | Evaluation Window |
|--------|-----------|-------------|------------------|--------------------|
| `process_resident_memory_bytes` | >1.5GB | Node pressure risk | Memory >1.5GB | Sustained 10 min |
| `process_cpu_seconds_total` | >80% core usage | Latency, node contention | High sustained CPU usage | 10 min average |
| `go_threads` | >1000 | Memory/thread leak | Threads >1000 | Continuous 5m |
