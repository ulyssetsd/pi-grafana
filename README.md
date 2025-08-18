# Raspberry Pi Monitoring Stack

Complete Kubernetes monitoring and logging infrastructure for Raspberry Pi using **Grafana, Prometheus, Loki, and Node Exporter** with GitOps deployment via **Flux**.

## 🚀 Features

✅ **Full Hardware Monitoring** - CPU, Memory, Disk, Network, Temperature  
✅ **Kubernetes Cluster Monitoring** - Pods, Deployments, Services, Nodes  
✅ **Complete Log Aggregation** - All pods and system logs via Loki  
✅ **Auto Data Source Provisioning** - Grafana ready out-of-the-box  
✅ **GitOps Ready** - Infrastructure as Code with Flux  
✅ **Production Grade** - RBAC, Persistent Storage, Retention Policies

## 📊 Recommended Dashboards

After deployment, import these proven dashboards in Grafana:

### Hardware Monitoring
- **Dashboard 1860** - Node Exporter Full (hardware metrics)
- **Dashboard 11074** - [Node Exporter Dashboard EN 20201010-StarsL.cn](https://grafana.com/grafana/dashboards/11074)

### Kubernetes Monitoring
- **Dashboard 7249** - [Kubernetes Cluster](https://grafana.com/grafana/dashboards/7249)
- **Dashboard 15661** - [K8S Dashboard EN](https://grafana.com/grafana/dashboards/15661)

### Logs Monitoring
- **Dashboard 14055** - [Loki Stack Monitoring (Promtail, Loki)](https://grafana.com/grafana/dashboards/14055)

## � Quick Deploy

### Option 1: Direct Kubernetes Apply
```bash
kubectl apply -f k8s/
kubectl get pods -n monitoring
```

### Option 2: GitOps with Flux (Recommended)
```bash
# Bootstrap Flux in your cluster
flux bootstrap github --owner=ulyssetsd --repository=pi-grafana --branch=main --path=k8s

# Flux will automatically deploy and maintain the stack
kubectl get kustomization -n flux-system
```

## 🔐 Access

- **Grafana**: https://grafana.ulyssetassidis.fr (update in `grafana.yaml`)
- **Default Login**: admin / admin123 ⚠️ *Change immediately!*

```logql
# All logs from monitoring namespace
{namespace="monitoring"}

# Logs from specific pod
{pod="prometheus-xxx"}

# Filter by log level
{namespace="monitoring"} |= "error"

# Logs from all containers of an app
{app="grafana"}

# System logs
{job="systemd-journal"}
```

## 🛠️ Management Commands

```bash
# Deploy/update the stack
kubectl apply -f k8s/

# Check status
kubectl get all -n monitoring

# View logs
kubectl logs -f deployment/grafana -n monitoring
kubectl logs -f deployment/prometheus -n monitoring

## 📁 Stack Components

```
k8s/
├── namespace.yaml             # monitoring namespace
├── prometheus-rbac.yaml       # RBAC for cluster-wide metrics
├── prometheus-config.yaml     # scraping configuration  
├── prometheus.yaml            # prometheus deployment
├── grafana-provisioning.yaml  # auto data source config
├── grafana.yaml              # grafana with ingress
├── node-exporter.yaml        # hardware metrics collector
├── kube-state-metrics.yaml   # kubernetes state metrics
├── loki-config.yaml          # log storage configuration
├── loki.yaml                 # loki deployment
├── promtail-config.yaml      # log collection rules
├── promtail.yaml             # log collection daemonset
└── kustomization.yaml        # deployment manifest
```

## 🏷️ What's Monitored

### Hardware (Node Exporter)
- CPU usage, load, temperature
- Memory, swap, disk usage  
- Network interfaces, traffic
- System uptime, processes

### Kubernetes (kube-state-metrics)
- Pod status, restarts, resources
- Deployment replicas, conditions
- Service endpoints, ingress
- Node status, capacity

### Logs (Promtail → Loki)
- All pod logs with metadata
- System logs (journal, syslog)
- JSON parsing, log levels
- 7-day retention, 10GB limit
```

## 🔧 Configuration

### Security
- **Change the default Grafana password** in `k8s/grafana.yaml`
- **Configure TLS certificates** for the ingress (cert-manager setup included)
- **Update the ingress hostname** in `k8s/grafana.yaml` to match your domain

### Storage
- **Grafana data**: 5GB persistent volume
- **Prometheus data**: Retention for 90 days or 10GB (whichever comes first)
- **Loki logs**: 10GB storage with 7-day retention

## 📊 What's Monitored & Logged

### 📈 Metrics (Prometheus)
- CPU usage and temperature
- Memory and disk usage
- Network traffic
- System uptime
- Process information

### 📋 Logs (Loki)
- **All Kubernetes pod logs** from every namespace
- **System logs** (syslog, systemd journal)
- **Container logs** with automatic JSON parsing
- **Application logs** with structured metadata
- **Real-time log streaming** and historical search

## 🔍 Troubleshooting

- **Can't access Grafana**: Check ingress configuration and DNS settings
- **Pods not starting**: Run `kubectl describe pods -n monitoring` to see events
- **Prometheus not scraping**: Verify node-exporter is running on target nodes
- **Permission issues**: Ensure your cluster has proper RBAC permissions

## 📁 Repository Structure

```
k8s/
├── namespace.yaml             # Monitoring namespace
├── grafana.yaml              # Grafana deployment, service, PVC, and ingress
├── grafana-provisioning.yaml # Prometheus & Loki data source configuration
├── prometheus.yaml           # Prometheus deployment and service
├── prometheus-config.yaml    # Prometheus scraping configuration
├── node-exporter.yaml       # Node exporter DaemonSet
├── loki.yaml                 # Loki deployment and service
├── loki-config.yaml          # Loki configuration
├── promtail.yaml             # Promtail DaemonSet for log collection
├── promtail-config.yaml      # Promtail scraping configuration
└── kustomization.yaml        # Kustomize configuration
```
