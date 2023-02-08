export INGRESS_DOMAIN="example.com"

envsubst < kiali-gateway.yaml      | kubectl apply -n istio-system -f -
envsubst < promethues-gateway.yaml | kubectl apply -n istio-system -f -
envsubst < grafana-gateway.yaml    | kubectl apply -n istio-system -f -
envsubst < jaeger-gateway.yaml     | kubectl apply -n istio-system -f -
