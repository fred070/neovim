# ✅ Availability Metrics for Kubernetes Core Components

| Component             | Metric                                                                 | Description                                                    | Threshold / Alert Condition                             | Severity | User Impact                                                   |
|-----------------------|-------------------------------------------------------------------------|----------------------------------------------------------------|----------------------------------------------------------|----------|----------------------------------------------------------------|
| API Server            | `up{job="apiserver"}`                                                   | Indicates if the API server is up                              | `up == 0` for 2 intervals                                | Critical | Kubernetes control plane is unavailable                      |
|                       | `apiserver_request_total`                                               | Total number of requests served                                | Sudden drop or zero for >2m                              | Critical | Unable to interact with cluster                              |
| etcd                  | `etcd_server_has_leader`                                                | Leader election status                                         | 0 for 2+ intervals                                        | Critical | etcd quorum loss; write ops fail                             |
|                       | `up{job="etcd"}`                                                        | Whether etcd target is up                                      | `up == 0`                                                | Critical | Cluster will become non-functional                           |
| kube-controller       | `up{job="kube-controller-manager"}`                                    | Controller Manager availability                                | `up == 0`                                                | Critical | Controllers won’t reconcile desired state                    |
|                       | `workqueue_depth{controller=...}`                                       | Queue backlog for a controller                                | Sustained > 100                                          | Warning  | Delayed reconciliation                                       |
| kube-scheduler        | `up{job="kube-scheduler"}`                                              | Scheduler process availability                                 | `up == 0`                                                | Critical | Pods won't be scheduled                                      |
|                       | `scheduler_schedule_attempts_total`                                    | Scheduling attempts                                            | Sharp drop to zero                                       | Warning  | No pods are being scheduled                                 |
| Container Runtime     | `container_runtime_operations_total`                                   | Total runtime operations                                       | Sudden drop or sustained zero                            | Critical | Pods may not start or restart properly                       |
| kubelet               | `kubelet_running_pod_count`                                             | Number of running pods per node                               | Drop to 0                                                 | Critical | Node not running workloads                                   |
|                       | `up{job="kubelet"}`                                                     | Whether kubelet is up on node                                 | `up == 0`                                                | Critical | Node not responding                                          |
| kube-proxy            | `up{job="kube-proxy"}`                                                  | Kube-proxy availability                                       | `up == 0`                                                | Warning  | Network rules not applied; DNS/service routing may break     |
| CoreDNS               | `up{job="coredns"}`                                                     | CoreDNS availability                                           | `up == 0`                                                | Critical | DNS resolution inside cluster fails                          |
|                       | `coredns_dns_request_count_total`                                      | DNS request volume                                             | Zero for 2+ intervals                                    | Warning  | DNS issues or inactivity                                    |
| Kubernetes Dashboard  | `up{job="kubernetes-dashboard"}`                                        | Dashboard service up                                           | `up == 0`                                                | Warning  | UI inaccessible                                               |
| NGINX Ingress         | `nginx_ingress_controller_nginx_process_requests_total`                | Total requests processed                                       | Zero for 2+ intervals                                    | Warning  | Ingress traffic dropped                                     |
|                       | `up{job="nginx-ingress-controller"}`                                   | Ingress controller pod up                                      | `up == 0`                                                | Critical | External access to services fails                           |

---

## ℹ️ Detailed Explanation

This section captures the **availability** of essential Kubernetes components through their corresponding Prometheus metrics:

- **`up{}`**: This is the standard Prometheus health check metric, where `up = 1` means the target is responding, and `up = 0` means it is unreachable.
- **API Server**: It’s the front door to the Kubernetes cluster. If it’s down, nothing in the cluster can be queried, configured, or controlled.
- **etcd**: As the key-value store of Kubernetes, etcd must always have a leader to allow read/write operations. Quorum loss leads to full control plane failure.
- **Controller Manager**: Controls replication, job completion, and garbage collection. A delay or failure here halts the self-healing nature of Kubernetes.
- **Scheduler**: Decides placement of new pods. If down, workloads won’t be assigned to nodes.
- **Container Runtime**: Responsible for running containers (e.g., containerd, CRI-O). If it’s failing, pods won’t start or stop.
- **Kubelet**: Manages each node, reports status, and ensures containers are healthy. If kubelet is down, the node is treated as unreachable.
- **Kube-proxy**: Handles cluster-level service routing. Its failure can cause broken service discovery and traffic issues.
- **CoreDNS**: Essential for name resolution. If it's down, services can’t find each other.
- **Ingress Controller**: Enables external traffic into the cluster. Failures block public access to services.
- **Dashboard**: While not critical to operations, its availability impacts observability and diagnostics via UI.
