# Raspberry Pi Monitoring with Grafana

Complete Kubernetes-based monitoring and logging stack for Raspberry Pi using Grafana, Prometheus, Loki, and Node Exporter with **automatic data source provisioning**.

## 🚀 Quick Start

Deploy the monitoring stack to your Kubernetes cluster:

```bash
# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Check deployment status
kubectl get pods -n monitoring
kubectl get services -n monitoring
```

## ✅ Live Setup

After deployment, access your services:

- **Grafana Dashboard**: https://grafana.ulyssetassidis.fr (or your configured domain)
- **Prometheus**: http://prometheus.monitoring.svc.cluster.local:9090
- **Loki**: http://loki.monitoring.svc.cluster.local:3100
- **Node Exporter**: Available on each node at port 9100

**Default Grafana Login**:
- Username: `admin`
- Password: `admin123` (⚠️ **Change this immediately in production!**)

## 📊 Dashboard Import (One-time setup)

After accessing Grafana:

1. Go to your Grafana URL
2. Click **"+" → "Import"**
3. Enter dashboard ID: **1860** → Select "Prometheus" data source → Import
4. Click **"+" → "Import"** again  
5. Enter dashboard ID: **11074** → Select "Prometheus" data source → Import

**That's it!** Your dashboards are now linked to Grafana.com and will show update notifications.

## 📜 Log Exploration

Access real-time logs from all your Kubernetes pods and system:

1. Go to Grafana → **Explore**
2. Select **Loki** as data source
3. Use LogQL queries:

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

# Scale components
kubectl scale deployment grafana --replicas=2 -n monitoring

# Delete the entire stack
kubectl delete -f k8s/
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
