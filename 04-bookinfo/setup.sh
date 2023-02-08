export INGRESS_DOMAIN="example.com"

kubectl create ns bookinfo

envsubst < bookinfo.yaml         | kubectl apply -n bookinfo -f -
envsubst < bookinfo-gateway.yaml | kubectl apply -n bookinfo -f -
