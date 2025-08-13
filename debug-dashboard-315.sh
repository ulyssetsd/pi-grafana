#!/bin/bash

# Diagnostic script for monitoring stack

echo "🔍 PI GRAFANA MONITORING STACK DIAGNOSTIC"
echo "=========================================="

echo "📊 Pod Status:"
kubectl get pods -n monitoring

echo -e "\n🔗 Service Status:" 
kubectl get svc -n monitoring

echo -e "\n🎯 Prometheus Targets Test:"
kubectl port-forward -n monitoring svc/prometheus 9090:9090 &
PF_PID=$!
sleep 3
curl -s http://localhost:9090/api/v1/targets 2>/dev/null | grep -o '"job":"[^"]*"' | sort | uniq || echo "❌ Prometheus unreachable"
kill $PF_PID 2>/dev/null

echo -e "\n📈 Sample Metrics Test:"
echo "Testing key metrics for dashboards..."
PROM_POD=$(kubectl get pod -n monitoring -l app=prometheus -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n monitoring $PROM_POD -- wget -q -O- http://node-exporter:9100/metrics 2>/dev/null | head -2 | grep -q "node_" && echo "✅ Node Exporter metrics OK" || echo "❌ Node Exporter metrics failed"
kubectl exec -n monitoring $PROM_POD -- wget -q -O- http://kube-state-metrics.monitoring.svc.cluster.local:8080/metrics 2>/dev/null | head -2 | grep -q "kube_" && echo "✅ Kube-state-metrics OK" || echo "❌ Kube-state-metrics failed"

echo -e "\n💡 Recommended Actions:"
echo "1. If all ✅ -> Import dashboard 1860 in Grafana"
echo "2. If ❌ Node Exporter -> Check node-exporter pod logs"  
echo "3. If ❌ Kube-state -> Check kube-state-metrics pod logs"
echo "4. If ❌ Prometheus -> Check prometheus pod logs and config"
