export INGRESS_DOMAIN="example.com"
export KUBECONFIG=../01-aks-setup/kubeconfig

#setup bookinfo application
kubectl create ns bookinfo

envsubst < bookinfo.yaml         | kubectl apply -n bookinfo -f -
envsubst < bookinfo-gateway.yaml | kubectl apply -n bookinfo -f -
