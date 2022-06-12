kubectl delete secrets qft-secrets
kubectl create secret generic qft-secrets --from-env-file .env.k8
kubectl delete deployments qft-api
kubectl apply -f qft.api.deployment.yml
kubectl delete deployments qft-auth
kubectl apply -f qft.goauth.deployment.yml