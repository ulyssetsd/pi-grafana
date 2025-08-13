#!/bin/bash

# Script de validation IaC pour debugging dashboard 315

echo "=== DIAGNOSTIC COMPLET DASHBOARD 315 ==="

echo "1. État des pods monitoring:"
kubectl get pods -n monitoring

echo -e "\n2. Services et leurs IPs:"
kubectl get svc -n monitoring

echo -e "\n3. Test connectivité kube-state-metrics:"
kubectl exec -n monitoring $(kubectl get pod -n monitoring -l app=prometheus -o jsonpath='{.items[0].metadata.name}') -- nslookup kube-state-metrics 2>/dev/null || echo "DNS lookup failed"

echo -e "\n4. Test métriques kube-state-metrics:"
kubectl exec -n monitoring $(kubectl get pod -n monitoring -l app=prometheus -o jsonpath='{.items[0].metadata.name}') -- wget -q -O- http://kube-state-metrics:8080/metrics 2>/dev/null | head -3 || echo "Métriques non accessibles"

echo -e "\n5. Configuration Prometheus (targets):"
kubectl port-forward -n monitoring svc/prometheus 9090:9090 &
PF_PID=$!
sleep 3
curl -s http://localhost:9090/api/v1/targets 2>/dev/null | grep -o '"job":"[^"]*"' | sort | uniq || echo "Prometheus API non accessible"
kill $PF_PID 2>/dev/null

echo -e "\n6. Exemple de métriques attendues par dashboard 315:"
echo "   - kube_deployment_status_replicas"
echo "   - kube_pod_info" 
echo "   - kube_node_info"

echo -e "\n=== ACTIONS RECOMMANDÉES ==="
echo "1. Si métriques accessibles mais pas dans Prometheus → Redémarrer Prometheus"
echo "2. Si DNS fail → Problème service"
echo "3. Si tout OK → Vérifier data source Grafana et time range"
