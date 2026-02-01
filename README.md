# Raspberry Pi Monitoring Stack

Kubernetes monitoring and logging infrastructure for Raspberry Pi using Grafana, Prometheus, Loki, and Node Exporter with GitOps deployment via Flux.

## Features

- Full Hardware Monitoring (CPU, Memory, Disk, Network, Temperature)
- Kubernetes Cluster Monitoring (Pods, Deployments, Services, Nodes)
- Complete Log Aggregation (All pods and system logs via Loki)
- Auto Data Source Provisioning (Grafana ready out-of-the-box)
- GitOps Ready (Infrastructure as Code with Flux)
- Production Grade (RBAC, Persistent Storage, Retention Policies)

## Recommended Dashboards

Import these dashboards in Grafana after deployment:

### Hardware Monitoring
- **Dashboard 1860** - Node Exporter Full (hardware metrics)
- **Dashboard 11074** - [Node Exporter Dashboard EN 20201010-StarsL.cn](https://grafana.com/grafana/dashboards/11074)

### Kubernetes Monitoring
- **Dashboard 7249** - [Kubernetes Cluster](https://grafana.com/grafana/dashboards/7249)
- **Dashboard 15661** - [K8S Dashboard EN](https://grafana.com/grafana/dashboards/15661)

### Logs Monitoring
- **Dashboard 14055** - [Loki Stack Monitoring (Promtail, Loki)](https://grafana.com/grafana/dashboards/14055)

## Quick Deploy

### Option 1: Direct Kubernetes Apply
```bash
kubectl apply -f k8s/
kubectl get pods -n monitoring
```

### Option 2: GitOps with Flux (Recommended)
```bash
# Bootstrap Flux in your cluster
flux bootstrap github --owner=ulyssetsd --repository=pi-grafana --branch=main --path=k8s
```

## Access

- **Grafana**: https://grafana.ulyssetassidis.fr
- **Login**: Use credentials configured during first setup

## Log Queries Examples

```logql
# All logs from monitoring namespace
{namespace="monitoring"}

# Filter by log level
{namespace="monitoring"} |= "error"

# System logs
{job="systemd-journal"}
```

## Management Commands

```bash
# Deploy/update the stack
kubectl apply -f k8s/

# Check status
kubectl get all -n monitoring

# View logs
kubectl logs -f deployment/grafana -n monitoring
```

## Stack Components

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

## What's Monitored

**Hardware (Node Exporter):**
CPU usage, memory, disk, network, temperature, uptime

**Kubernetes (kube-state-metrics):**
Pod status, deployments, services, node capacity

**Logs (Promtail → Loki):**
All pod logs, system logs, JSON parsing, 7-day retention

## Configuration

**Customization:**
- Update ingress hostname in `k8s/grafana.yaml` for your domain
- Grafana admin password is set via environment variable in `k8s/grafana.yaml`

**Storage:**
- Grafana: 5GB persistent volume
- Prometheus: 90 days retention / 10GB limit
- Loki: 10GB storage / 7-day retention
