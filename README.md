# Raspberry Pi Monitoring with Grafana

Complete monitoring stack for Raspberry Pi using Grafana, Prometheus, and Node Exporter with **automatic data source provisioning**.

## ✅ Live Setup

- **Grafana Dashboard**: http://raspberrypi.local:3000
- **Prometheus**: http://raspberrypi.local:9090 (http://prometheus:9090)
- **Node Exporter**: http://raspberrypi.local:9100/metrics

**Recommended Dashboards to Import**:
- **Dashboard 1860** (Node Exporter Full) - Comprehensive system metrics
- **Dashboard 11074** (Raspberry Pi Monitoring) - Specialized Pi monitoring

## 📊 Dashboard Import (One-time setup)

After starting the containers:

1. Go to http://raspberrypi.local:3000
2. Click **"+" → "Import"**
3. Enter dashboard ID: **1860** → Select "Prometheus" data source → Import
4. Click **"+" → "Import"** again  
5. Enter dashboard ID: **11074** → Select "Prometheus" data source → Import

**That's it!** Your dashboards are now linked to Grafana.com and will show update notifications.

## Management Commands

```bash
cd /home/ulysse/code/pi-grafana

# Start/restart
docker-compose up -d

# Stop
docker-compose down

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

## Data Retention

Prometheus keeps metrics for **90 days** or **10GB** (whichever comes first).

## What's Monitored

- CPU usage and temperature
- Memory and disk usage
- Network traffic
- System uptime
- Process information

## Troubleshooting

- **Can't access services**: Check `docker-compose ps` to ensure containers are running
- **Permission denied**: Log out and back in if you can't run docker without sudo
- **Port conflicts**: Ensure ports 3000, 9090, 9100 are available
