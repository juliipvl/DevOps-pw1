Write-Host "Starting Minikube cluster..." -ForegroundColor Cyan
minikube start --driver=docker

Write-Host "Enabling metrics-server..." -ForegroundColor Cyan
minikube addons enable metrics-server

Write-Host "Building API image inside Minikube..." -ForegroundColor Cyan
minikube image build -t todo-api:1.0 .

Write-Host "Applying high-level Kubernetes configuration..." -ForegroundColor Cyan
kubectl apply -f k8s\high-level-pods.yaml

Write-Host "Applying hostPath volume configuration..." -ForegroundColor Cyan
kubectl apply -f k8s\hostpath-volume.yaml

Write-Host "Waiting for pods to become ready..." -ForegroundColor Cyan
kubectl wait --for=condition=Ready pod/db-pod --timeout=180s
kubectl wait --for=condition=Ready pod/api-pod --timeout=180s
kubectl wait --for=condition=Ready pod/pgadmin-pod --timeout=180s
kubectl wait --for=condition=Ready pod/hostpath-writer-pod --timeout=180s
kubectl wait --for=condition=Ready pod/hostpath-reader-pod --timeout=180s

Write-Host "Waiting for metrics-server..." -ForegroundColor Cyan
Start-Sleep -Seconds 90

Write-Host "Pods:" -ForegroundColor Green
kubectl get pods

Write-Host "Services:" -ForegroundColor Green
kubectl get services

Write-Host "Resource usage by pods:" -ForegroundColor Green
kubectl top pods

Write-Host "Resource usage by node:" -ForegroundColor Green
kubectl top nodes

Write-Host "HostPath reader logs:" -ForegroundColor Green
kubectl logs hostpath-reader-pod

Write-Host "Kubernetes setup completed." -ForegroundColor Cyan