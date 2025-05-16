# 📥 Queue Length & Saturation Metrics

| Layer      | Category       | Metric                                                                 | Description                                                       | Threshold                     | Severity | Alert Condition                            | User Impact                                                     |
|------------|----------------|-------------------------------------------------------------------------|-------------------------------------------------------------------|-------------------------------|----------|--------------------------------------------|------------------------------------------------------------------|
| Cluster    | API Saturation | `apiserver_current_inflight_requests{request_kind="mutating"}`         | Number of in-flight mutating requests (e.g., POST, PUT, DELETE)  | >80% of configured max        | Warning  | Sustained high usage for 3 intervals        | API responsiveness degradation for write operations              |
| Cluster    | API Saturation | `apiserver_current_inflight_requests{request_kind="non-mutating"}`     | In-flight non-mutating requests (e.g., GET, LIST, WATCH)          | >90% of configured max        | Warning  | High sustained load over 5 minutes          | Read operation latency, 429 errors likely                       |
| Cluster    | API Queue      | `apiserver_request_queue_length` *(if custom instrumented)*            | Length of API server internal request queue                       | >100                          | Warning  | Queue length exceeds threshold for 3 mins   | Delays in processing incoming requests                           |
| Scheduler  | Scheduling     | `scheduler_pending_pods` *(custom)*                                     | Number of pods pending scheduling                                 | >50 pods                      | Warning  | Sustained over 5 mins                      | Scheduling bottlenecks, resource contention                      |
| Kubelet    | Pod Launch     | `kubelet_pod_worker_duration_seconds_bucket`                           | Time kubelet takes to start a pod (saturation proxy)              | >95th percentile >10s         | Warning  | Sustained over 3 intervals                  | Node under pressure or disk/network I/O latency                 |
| Ingress    | Request Queue  | `nginx_ingress_controller_request_duration_seconds_bucket`             | Ingress request latency (proxy to backend queue pressure)         | 95th percentile > 1s          | Warning  | Sustained over 3 intervals                  | Backend apps overwhelmed or slow                                |

---

## ℹ️ Explanations

### What is Queue Length?
Queue length represents the number of operations waiting to be processed. This can include:

- API requests pending in the server
- Pods waiting to be scheduled
- Network requests pending at ingress

High queue length usually indicates **resource contention**, **insufficient capacity**, or **upstream bottlenecks**.

### What is Saturation?
Saturation is a measure of how full a system or component is relative to its capacity. It's part of the **USE Method** (Utilization, Saturation, Errors) for performance monitoring.

- A component is saturated when it's running at full capacity and requests must queue.
- Examples include CPU saturation, API server inflight request limits, and ingress latency.

### Why Monitor These?
- Prevent slowdowns or unresponsiveness under load.
- Detect resource bottlenecks early.
- Ensure systems can scale with demand.
