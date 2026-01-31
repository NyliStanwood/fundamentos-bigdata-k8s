# Kubernetes Services Mapping

This document maps each service defined in docker-compose.yml to the appropriate Kubernetes resources you will need to create. This mapping will help you write the necessary Kubernetes manifests for your local Minikube cluster.

---

## 1. kafka

- **Kubernetes Deployment**: For running the Kafka broker container.
- **Kubernetes Service**: To expose port 9092 within the cluster (and optionally as NodePort for local access).
- **ConfigMap**: For environment variables (optional, for clarity).
- **Resource Limits**: Set CPU/memory requests and limits.
- **Notes**: Needs a persistent volume if you want to persist data (not defined in Compose).

## 2. kafka-init

- **Kubernetes Job**: For one-time topic creation (runs once, then exits).
- **ConfigMap**: For command/entrypoint (optional).
- **Dependencies**: Use `initContainers` or `Job` with `dependsOn` logic (wait for kafka to be ready).

## 3. mongo

- **Kubernetes Deployment**: For the MongoDB container.
- **Kubernetes Service**: To expose port 27017 within the cluster.
- **PersistentVolumeClaim**: For `mongo_data` volume.
- **ConfigMap/Secret**: For environment variables (credentials).
- **Resource Limits**: Set CPU/memory requests and limits.
- **VolumeMounts**: For ./resources and ./data (use hostPath for local dev, or ConfigMap for static files).

## 4. spark-master

- **Kubernetes Deployment**: For the Spark master node.
- **Kubernetes Service**: To expose ports 8080 (UI) and 7077 (cluster comms).
- **ConfigMap**: For environment variables (optional).
- **Resource Limits**: Set CPU/memory requests and limits.

## 5. spark-worker-1 & spark-worker-2

- **Kubernetes Deployment**: One deployment for each worker (or use a single deployment with 2 replicas).
- **Kubernetes Service**: For UI port (8081 for worker-1, 8082 for worker-2).
- **ConfigMap**: For environment variables (optional).
- **Resource Limits**: Set CPU/memory requests and limits.
- **VolumeMounts**: For ./models (use hostPath for local dev).

## 6. sparksubmit

- **Kubernetes Job**: For submitting Spark jobs (runs and exits).
- **ConfigMap**: For environment variables (optional).
- **Resource Limits**: Set CPU/memory requests and limits.
- **VolumeMounts**: For ./models (use hostPath for local dev).

## 7. flask

- **Kubernetes Deployment**: For the Flask app.
- **Kubernetes Service**: To expose port 5001 (ClusterIP or NodePort for local access).
- **ConfigMap**: For environment variables (optional).
- **Resource Limits**: Set CPU/memory requests and limits.
- **VolumeMounts**: For ./resources (use hostPath for local dev).

---

## Networks

- All services use `flight-network` in Compose. In Kubernetes, all pods/services are on the same network by default (no need to define a custom network).

## Volumes

- `mongo_data`: Use a PersistentVolume and PersistentVolumeClaim.
- `./resources`, `./data`, `./models`: Use hostPath volumes for local development, or ConfigMap for static content.

---

This mapping will help you write the corresponding Kubernetes YAML files for each service. Each service will typically need at least a Deployment and a Service, and some will need PersistentVolumes, ConfigMaps, or Jobs. If you need example YAMLs for any of these, let me know!
