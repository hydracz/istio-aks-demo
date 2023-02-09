export KUBECONFIG=../01-aks-setup/kubeconfig

kubectl label namespace bookinfo istio-injection=enabled --overwrite
kubectl apply -f destination-rule-all.yaml
