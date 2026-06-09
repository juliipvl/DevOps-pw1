Write-Host "Starting Minikube cluster..." -ForegroundColor Cyan
minikube start --driver=docker

Write-Host "Enabling metrics-server..." -ForegroundColor Cyan
minikube addons enable metrics-server

Write-Host "Enabling ingress addon..." -ForegroundColor Cyan
minikube addons enable ingress

Write-Host "Building API image inside Minikube..." -ForegroundColor Cyan
minikube image build -t todo-api:1.0 .

Write-Host "Applying Kubernetes deployments..." -ForegroundColor Cyan
kubectl apply -f k8s\deployments

Write-Host "Applying Kubernetes services..." -ForegroundColor Cyan
kubectl apply -f k8s\services

Write-Host "Applying Kubernetes ingress..." -ForegroundColor Cyan
kubectl apply -f k8s\ingress

Write-Host "Applying hostPath volume configuration..." -ForegroundColor Cyan
kubectl apply -f k8s\volumes

Write-Host "Waiting for deployments to become ready..." -ForegroundColor Cyan
kubectl rollout status deployment/db-deployment --timeout=180s
kubectl rollout status deployment/api-deployment --timeout=180s
kubectl rollout status deployment/pgadmin-deployment --timeout=180s

Write-Host "Waiting for hostPath pods to become ready..." -ForegroundColor Cyan
kubectl wait --for=condition=Ready pod/hostpath-writer-pod --timeout=180s
kubectl wait --for=condition=Ready pod/hostpath-reader-pod --timeout=180s

Write-Host "Waiting for metrics-server and ingress..." -ForegroundColor Cyan
Start-Sleep -Seconds 90

Write-Host "Deployments:" -ForegroundColor Green
kubectl get deployments

Write-Host "Pods:" -ForegroundColor Green
kubectl get pods

Write-Host "Services:" -ForegroundColor Green
kubectl get services

Write-Host "Ingress:" -ForegroundColor Green
kubectl get ingress

Write-Host "Resource usage by pods:" -ForegroundColor Green
kubectl top pods

Write-Host "Resource usage by node:" -ForegroundColor Green
kubectl top nodes

Write-Host "HostPath reader logs:" -ForegroundColor Green
kubectl logs hostpath-reader-pod

Write-Host "Kubernetes setup completed." -ForegroundColor Cyan