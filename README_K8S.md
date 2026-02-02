This README provides a guide to deploying the flight prediction application to a local Kubernetes cluster using Minikube.

## Kubernetes Deployment for Flight Prediction

This document outlines the steps and resources needed to deploy the distributed flight prediction application using Kubernetes. It is based on the services defined in the `docker-compose.yml` and translated into Kubernetes manifests.

### Ubuntu VM Setup (Ubuntu 22.04 LTS)

These instructions are for setting up the environment on a fresh Ubuntu 22.04 LTS virtual machine.
**Minimum tested resources:** e2-standard-8 (8 vCPUs, 32 GB Memory).

#### 1. System Preparation and Tool Installation

Update your package list and install necessary tools like `git`, `curl`, `docker`, `kubectl`, and `minikube`.

```bash
# Update package manager
sudo apt-get update

# Install git, curl, docker, and kubectl
sudo apt-get install -y git curl
sudo apt-get install -y docker.io docker-compose
sudo apt-get install -y kubectl

# Install Minikube
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

# Start, enable, and configure Docker permissions
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

#### 2. Clone Repository

Clone the project repository and navigate into the directory.

```bash
git clone https://github.com/NyliStanwood/fundamentos-bigdata-k8s.git
cd fundamentos-bigdata-k8s
```

#### 3. Start Minikube and Build Docker Images

Start a Minikube instance with a specific profile and resources, then build the required Docker images within Minikube's Docker environment.

```bash
# Start Minikube with a specific profile and resources
minikube start --driver=docker -p practica-creativa --cpus=7 --memory=10000mb

# List and enable required addons for the profile
minikube addons list -p practica-creativa
minikube addons enable registry -p practica-creativa
minikube addons enable metrics-server -p practica-creativa

# Set the Docker environment to Minikube's
eval $(minikube -p practica-creativa docker-env)

# Build custom Docker images
docker build -t spark-master-custom:3.5.3 -f Dockerfile.spark-master .
docker build --no-cache -t sparksubmit-custom:3.5.3 -f Dockerfile.sparksubmit .
docker build --no-cache -t spark-worker-1-custom:3.5.3 -f Dockerfile.spark-worker .
docker build --no-cache -t spark-worker-2-custom:3.5.3 -f Dockerfile.spark-worker .
docker build --no-cache -t flask-custom:3.5.3 -f Dockerfile.flask .
docker build --no-cache -t mongo-cust-c:7.0 -f Dockerfile.mongo .

# Unset the Docker environment
eval $(minikube -p practica-creativa docker-env -u)
```

### Firewall Configuration

To allow external traffic to access the Flask service, you need to create a firewall rule in your cloud provider's console (e.g., Google Cloud Platform).

**Create a new firewall rule with the following settings:**

- **Name**: `allow-flask-5001`
- **Direction of traffic**: `Ingress`
- **Action on match**: `Allow`
- **Targets**: `Apply to all` (or specify the tags of your cluster nodes)
- **Source filter**: `IP ranges`
- **Source IP ranges**: `0.0.0.0/0`
- **Protocols and ports**:
  - `Specified protocols and ports`
  - `tcp`: `5001`

This rule will open port `5001` to all incoming traffic, allowing users to access the web interface of the Flask application.

#### 4. Deploy to Kubernetes

Create a dedicated namespace and deploy all the application resources.

```bash
# Create a specific namespace
kubectl create namespace pc-k8s

# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Check the status of the pods in the namespace
kubectl get pods -n pc-k8s
```

#### 5. Management and Troubleshooting

Here are some commands to manage and troubleshoot the deployment.

##### Restart All Pods

To apply changes or restart the application:

```bash
# Re-apply manifests and then delete all pods to force a restart
kubectl apply -f k8s/
kubectl delete pods --all -n pc-k8s
kubectl get pods -n pc-k8s
```

##### Rerun a Specific Job

To delete and re-apply a Job like `kafka-init` or `sparksubmit`:

```bash
# Example for kafka-init-job
kubectl delete -f k8s/kafka-init-job.yaml
kubectl apply -f k8s/kafka-init-job.yaml

# Example for sparksubmit-job
kubectl delete -f k8s/sparksubmit-job.yaml
kubectl apply -f k8s/sparksubmit-job.yaml
```

##### Update from Git

To pull the latest changes and redeploy:

```bash
git pull
kubectl apply -f k8s/
kubectl delete pods --all -n pc-k8s
kubectl get pods -n pc-k8s
```

#### 6. Exposing Services

To access the Flask service from outside the cluster, use `port-forward`.

```bash
# Forward the Flask service port to your local machine
# kubectl port-forward --address 0.0.0.0 -n pc-k8s svc/flask-svc 8888:5001

# Alternative: Forward directly to the pod
kubectl port-forward --namespace pc-k8s --address 0.0.0.0 $(kubectl get pods --namespace pc-k8s -l 'app=flask' -o jsonpath='{.items[0].metadata.name}') 5001:5001
```

#### 7. Starting Fresh

To completely remove all resources and start over:

```bash
# Delete all resources in the namespace
kubectl delete all --all -n pc-k8s

# Delete all Persistent Volume Claims, ConfigMaps, and Secrets
kubectl delete pvc --all -n pc-k8s
kubectl delete configmap --all -n pc-k8s
kubectl delete secret --all -n pc-k8s

# Delete the namespace itself
kubectl delete namespace pc-k8s

# You can then pull changes and redeploy
git pull
kubectl create namespace pc-k8s
kubectl apply -f k8s/
kubectl get pods -n pc-k8s
```

### Prerequisites

- **kubectl**: The command-line tool for interacting with Kubernetes clusters.
- **Minikube**: A tool to run a single-node Kubernetes cluster locally.
- **Docker**: As the container runtime for Minikube.

### Initial Setup

1.  **Start Minikube**:
    Start your local Kubernetes cluster using Docker as the driver.

    ```bash
    minikube start --driver=docker
    ```

2.  **Enable Minikube Addons**:
    Enable the registry and metrics-server addons.

    ```bash
    minikube addons enable registry
    minikube addons enable metrics-server
    ```

3.  **Set Docker Environment**:
    Configure your shell to use Minikube's Docker daemon.

    For PowerShell:

    ```powershell
    & minikube docker-env | Invoke-Expression
    ```

    For bash/zsh:

    ```bash
    eval $(minikube docker-env)
    ```

### Services and Kubernetes Resources

The following is a mapping of the Docker Compose services to their corresponding Kubernetes resources. All YAML files are located in the `/k8s` directory.

| Service           | Kubernetes Resources                                                                                                                 | Description                                                                                                                 |
| :---------------- | :----------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| **Kafka**         | `kafka-pvc.yaml`<br>`kafka-deployment.yaml`<br>`kafka-service.yaml`                                                                  | A PersistentVolumeClaim for data persistence, a Deployment for the Kafka broker, and a Service to expose it.                |
| **Kafka-Init**    | `kafka-init-job.yaml`                                                                                                                | A Job that runs once to create the necessary Kafka topics. It depends on Kafka being ready.                                 |
| **Mongo**         | `mongo-pvc.yaml`<br>`mongo-deployment.yaml`<br>`mongo-service.yaml`                                                                  | A PersistentVolumeClaim for the database, a Deployment for the MongoDB instance, and a Service for cluster-internal access. |
| **Spark Master**  | `spark-master-deployment.yaml`<br>`spark-master-service.yaml`                                                                        | A Deployment for the Spark master node and a Service to expose its UI and communication ports.                              |
| **Spark Workers** | `spark-worker-1-deployment.yaml`<br>`spark-worker-1-service.yaml`<br>`spark-worker-2-deployment.txt`<br>`spark-worker-2-service.txt` | Deployments and Services for the Spark worker nodes.                                                                        |
| **Spark Submit**  | `sparksubmit-job.yaml`                                                                                                               | A Job to submit Spark applications to the cluster.                                                                          |
| **Flask**         | `flask-deployment.yaml`<br>`flask-service.yaml`                                                                                      | A Deployment for the Flask web application and a Service to expose it for access.                                           |

### Deployment

To deploy all the resources, you can apply all the YAML files in the `k8s` directory:

```bash
kubectl apply -f k8s/
```

### Useful Commands

Here are some common `kubectl` commands for managing the deployment:

- **List all pods**:
  ```bash
  kubectl get pods
  ```
- **List all services**:
  ```bash
  kubectl get services
  ```
- **List all deployments**:
  ```bash
  kubectl get deployments
  ```
- **List all jobs**:
  ```bash
  kubectl get jobs
  ```
- **View logs for a pod**:
  ```bash
  kubectl logs <pod-name>
  ```
- **Describe a pod for details and events**:
  ```bash
  kubectl describe pod <pod-name>
  ```
- **Access the Minikube dashboard**:
  ```bash
  minikube dashboard
  ```
- **Delete all resources**:
  ```bash
  kubectl delete -f k8s/
  ```

For convenience in PowerShell, you can create an alias for `kubectl`:

```powershell
New-Alias -Name k -Value kubectl
```

To make it persistent, add it to your PowerShell profile (`$PROFILE`).
