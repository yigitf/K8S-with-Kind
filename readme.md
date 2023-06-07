# Prerequisites: 
Docker veya Docker-Desktop
Git Bash


### JAVA APPLICATION & DOCKERFILE ###

# Clone the sample java app
git clone https://github.com/SampleJavaApp/app.git

# Create the image from java app
docker build -t fatih-app:0.0.1 .


### KUBERNETES CLUSTER ###

# Creating the Kubernetes Cluster with Kind
.\kind.exe create cluster --config kind-config.yaml

# Install Ingress Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# Importing the java app image
.\kind.exe load docker-image fatih-app:0.0.1

# Namespace, Deployment, Service, Ingress, HPA 
kubectl apply -f application/namespace.yaml
kubectl apply -f application/deployment.yaml
kubectl apply -f application/service.yaml
kubectl apply -f application/ingress.yaml
kubectl apply -f application/hpa.yaml

# To test the application:
http://localhost/api/foos?val=TEST


### MONITORING (extra) ###

# Kubernetes dashboard setup and admin user definition
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f monitoring/admin-user.yaml 
kubectl proxy

# Creating administrator token for K8s Dashboard:
kubectl -n kubernetes-dashboard create token admin-user

# To access the dashboard via browser:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

# Installation the Chocolatey and Helm (Powershell/Administrative)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install kubernetes-helm

# Installation Loki, Prometheus and Grafana

helm repo add grafana https://grafana.github.io/helm-charts

helm repo add Prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install loki grafana/loki-stack --namespace log-monitoring --create-namespace --set grafana.enabled=true

helm install prometheus Prometheus-community/kube-prometheus-stack --namespace metrics-monitoring --create-namespace

kubectl get secret -n metrics-monitoring prometheus-grafana -o yaml

kubectl port-forward --namespace metrics-monitoring service/prometheus-grafana 3000:80

http://localhost:3000
http://loki-gateway.log-monitoring.svc.cluster.local


# Load test (python required)

pip install requests

python bot/test.py










# Destroy Everything
.\kind.exe delete cluster 
