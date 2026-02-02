kubectl y minikube son herramientas diferentes que se complementan en el contexto de Kubernetes:

    kubectl: Es la interfaz de línea de comandos para interactuar con clústeres de Kubernetes. Te permite gestionar recursos, ejecutar comandos y obtener información sobre el estado de tus aplicaciones en el clúster.

    minikube: Es una herramienta que permite crear y gestionar un clúster de Kubernetes de forma local en tu máquina. Proporciona un entorno de desarrollo para que puedas experimentar con Kubernetes sin necesidad de una infraestructura compleja.

    Los addons mencionados en el contexto son herramientas adicionales que puedes habilitar en Minikube para mejorar la funcionalidad de tu clúster local de Kubernetes. Por ejemplo, el "registry" permite almacenar imágenes de contenedores localmente, facilitando su acceso y gestión.

    El "metric server" recopila métricas de los recursos utilizados por los pods, lo que es útil para monitorear el rendimiento y escalabilidad de las aplicaciones. Estos addons son esenciales para simular un entorno de producción más realista y gestionar mejor tus aplicaciones en Kubernetes

Requieres ambos porque minikube crea el clúster local y kubectl te permite interactuar con ese clúster.

Los comandos utilizados incluyen:

    kubectl --help: Muestra la ayuda de comandos básicos para kubectl.

    minikube --help: Muestra las opciones disponibles para minikube.

    minikube start --driver=docker: Inicia un clúster de Minikube utilizando Docker como driver.

    kubectl get nodes: Muestra los nodos en el clúster.

    minikube addons list: Lista los complementos disponibles en Minikube.

    minikube addons enable registry: Habilita el registro local.

    minikube addons enable metrics-server: Habilita el servidor de métricas.

    kubectl config get-contexts: para saber si estamos trabajando en una maquina local o en una maquina remota

    kubectl config use-context <some_context_here>: para cambiar el contexto de trabajo

    kubectl config use-context minikube: para usar el cluster local minikube (unico installed here)

    kubectl get pods : para obtener una lista de los pods en el contexto

    minikube dashboard : para comenzar el webserver y acceder a la UI

kubectl run hello-cloud --image=gcr.io/google-samples/hello-app:2.0 --restart=Never --port=8080

eval $(minikube docker-env)

deberás usar el siguiente comando en PowerShell:
& minikube docker-env | Invoke-Expression

FOR METRICS ADDON:
https://github.com/kubernetes/minikube/blob/master/OWNERS  
▪ Using image registry.k8s.io/metrics-server/metrics-server:v0.8.0

FOR REGISTRY ADDON:
https://github.com/kubernetes/minikube/blob/master/OWNERS  
╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ │  
│ Registry addon with docker driver uses port 56497 please use that instead of default port 5000 │  
│ │  
╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯  
📘 For more information see: https://minikube.sigs.k8s.io/docs/drivers/docker
▪ Using image docker.io/registry:3.0.0
▪ Using image gcr.io/k8s-minikube/kube-registry-proxy:0.0.9

Comandos para manejar Pods

    Listar Pods kubectl get pods Muestra todos los pods en el namespace actual. Para ver los pods en otro namespace, agrega el flag --namespace=<namespace>.
    Desplegar un Pod kubectl run <nombre-del-pod> --image=<imagen> --restart=Never Crea un pod con el nombre y la imagen especificados. El flag --restart=Never se usa para asegurar que el pod no se reinicie como un Deployment.
    Ver los detalles de un Pod kubectl describe pod <nombre-del-pod> Muestra información detallada sobre un pod, incluidos sus eventos, contenedores, volúmenes, etc.
    Obtener logs de un Pod kubectl logs <nombre-del-pod> Muestra los logs de un pod. Si el pod tiene varios contenedores, puedes especificar el contenedor con el flag -c.
    Eliminar un Pod kubectl delete pod <nombre-del-pod> Elimina el pod especificado.

Comandos para manejar Nodos

    Listar Nodos kubectl get nodes Muestra una lista de todos los nodos en el clúster.
    Ver los detalles de un Nodo kubectl describe node <nombre-del-nodo> Muestra información detallada sobre un nodo, como la memoria, CPU y recursos disponibles.
    Eliminar un Nodo kubectl delete node <nombre-del-nodo> Elimina el nodo del clúster (no eliminará los pods en el nodo, pero podría afectar su disponibilidad).
    Ver el estado de los Pods en los Nodos kubectl get pods --all-namespaces -o wide Muestra todos los pods de todos los namespaces y en qué nodo están corriendo.

Comandos para manejar Namespaces

    Listar Namespaces kubectl get namespaces Muestra todos los namespaces en el clúster.
    Crear un Namespace kubectl create namespace <nombre-del-namespace> Crea un nuevo namespace con el nombre especificado.
    Cambiar de Namespace kubectl config set-context --current --namespace=<nombre-del-namespace> Cambia el namespace predeterminado para las siguientes operaciones.
    Eliminar un Namespace kubectl delete namespace <nombre-del-namespace> Elimina el namespace especificado y todos los recursos dentro de él.
    Listar los Pods en un Namespace específico kubectl get pods --namespace=<nombre-del-namespace> Muestra los pods dentro de un namespace específico.

Los comandos más relevantes mencionados en el transcript y su propósito son:

    kubectl get pods: Muestra todos los pods en el namespace actual (por defecto, 'default').
    kubectl get namespaces: Lista todos los namespaces disponibles.
    kubectl create namespace <nombre>: Crea un nuevo namespace.
    kubectl create pod: Crea un pod en un namespace específico.
    kubectl apply -f <archivo.yaml>: Crea o actualiza recursos de Kubernetes a partir de un archivo YAML, utilizado para deployments y replica sets.
    kubectl get replicasets: Muestra todos los replica sets en ejecución.
    kubectl describe pod <nombre>: Proporciona detalles sobre un pod específico.
    kubectl delete pod <nombre>: Elimina un pod.

en Windows para configurar el alias para el comando kubectl:

New-Alias -Name k kubectl

puedes agregarlo a tu $PROFILE para que persista en cualquier sesión de la terminal que inicies:

1. Crealo (opcional, si no existe): New-Item -Path $PROFILE -Type File -Force 2. notepad $PROFILE 3. editalo agregando New-Alias -Name k kubectl

COMMANDS USED

docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
docker-compose down

& minikube -p practica-creativa docker-env | Invoke-Expression

# create the cluster

minikube start --driver=docker -p practica-creativa --cpus=7 --memory=7000mb --driver=docker
minikube addons list -p practica-creativa
minikube addons enable registry -p practica-creativa
minikube addons enable metrics-server -p practica-creativa
minikube dashboard -p practica-creativa

& minikube -p practica-creativa docker-env | Invoke-Expression
eval $(minikube docker-env)
eval $(minikube -p practica-creativa docker-env)
docker build -t spark-master-custom:3.5.3 -f Dockerfile.spark-master .
docker build --no-cache -t spark-worker-1-custom:3.5.3 -f Dockerfile.spark-worker .
docker build --no-cache -t spark-worker-2-custom:3.5.3 -f Dockerfile.spark-worker .
docker build --no-cache -t sparksubmit-custom:3.5.3 -f Dockerfile.sparksubmit .
docker build --no-cache -t mongo-cust-c:7.0 -f Dockerfile.mongo .
docker build --no-cache -t sparksubmit-custom:3.5.3 -f Dockerfile.sparksubmit .
docker build --no-cache -t flask-custom:3.5.3 -f Dockerfile.flask .
eval $(minikube -p practica-creativa docker-env -u)

minikube -p practica-creativa image build -t flask-custom:3.5.3 -f Dockerfile.flask .

& minikube -p practica-creativa docker-env -u | Invoke-Expression
& minikube -p practica-creativa ssh docker images

# create specifi namespace

git pull
kubectl create namespace pc-k8s
kubectl apply -f k8s/
kubectl get pods -n pc-k8s

minikube -p practica-creativa service flask-svc -n pc-k8s

kubectl logs -f sparksubmit-mz6hn -n pc-k8s
kubectl exec -it mongo-7c7df99999-btgck -n pc-k8s -- head -20 /docker-entrypoint-initdb.d/mongo-init.sh

kubectl delete pod -n pc-k8s -l app=spark-master
kubectl apply -f k8s/spark-master-deployment.yaml
kubectl apply -f k8s/flask-service.yaml
kubectl apply -f k8s/mongo-deployment.yaml
kubectl apply -f spark-worker-1-deployment.yaml
kubectl apply -f spark-worker-2-deployment.yaml

minikube dashboard -p practica-creativa

# delete resources

kubectl delete all --all -n pc-k8s
kubectl delete pvc --all -n pc-k8s
kubectl delete configmap --all -n pc-k8s
kubectl delete secret --all -n pc-k8s
kubectl delete namespace pc-k8s
minikube stop -p practica-creativa
minikube delete -p practica-creativa

& minikube -p practica-creativa docker-env -u | Invoke-Expression

kubectl get flask-svc -n pc-k8s
kubectl expose deployment flask --type=NodePort --port=5001 -n pc-k8s

minikube -p practica-creativa ip
192.168.58.2
minikube -p practica-creativa tunnel
minikube -p practica-creativa service flask-svc -n pc-k8s
kubectl port-forward --address 0.0.0.0 -n pc-k8s svc/flask-svc 8888:5001

SPARKSUBMIT
kubectl delete -n pc-k8s -f k8s/sparksubmit-job.yaml
kubectl apply -f k8s/

kubectl exec -it sparksubmit-dbppq -n pc-k8s -- rm -rf /tmp/kafka_checkpoint

FLASK
kubectl delete -f k8s/flask-deployment.yaml -n pc-k8s
kubectl delete -f k8s/flask-service.yaml -n pc-k8s
kubectl apply -f k8s/
kubectl get pods -n pc-k8s
minikube -p practica-creativa tunnel
minikube -p practica-creativa service flask-svc -n pc-k8s

KAFKA
kubectl delete -f k8s/kafka-init-job.yaml -n pc-k8s
kubectl delete -f k8s/kafka-deployment.yaml -n pc-k8s
kubectl apply -f k8s/
kubectl get pods -n pc-k8s
kubectl exec -n pc-k8s kafka-5f7f4df6fc-lfwnm -- bash -c "/opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092"

# Get the new pod name first

kubectl get pods -n pc-k8s -l app=kafka

echo '{"test":"message"}' | kubectl exec -i -n pc-k8s kafka-5f7f4df6fc-lfwnm -- /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic flight-delay-ml-response

kubectl exec -n pc-k8s kafka-5f7f4df6fc-lfwnm -- /opt/kafka/bin/kafka-console-consumer.sh \
 --bootstrap-server localhost:9092 \
 --topic flight-delay-ml-response \
 --from-beginning

kubectl exec -it -n pc-k8s kafka-5f7f4df6fc-lfwnm -- /opt/kafka/bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic flight-delay-ml-response

mongo
kubectl delete -f k8s/mongo-deployment.yaml -n pc-k8s
kubectl delete pvc mongo-pvc -n pc-k8s
kubectl get pvc -n pc-k8s
kubectl apply -f k8s/
kubectl get pods -n pc-k8s

kubectl exec -it -n pc-k8s mongo-68649575d-jrsvv -- bash
mongosh -u root -p example
use agile_data_science
db.origin_dest_distances.countDocuments()
db.origin_dest_distances.findOne()
db.flight_delay_ml_response.findOne()

kubectl logs -f mongo-68649575d-hbzhl -n pc-k8s
kubectl exec -it mongo-7c7df99999-25p5t -n pc-k8s -- head -20 /docker-entrypoint-initdb.d/mongo-init.sh
kubectl exec -it spark-worker-1-76bbf76bd4-9k2s9 -n pc-k8s -- /bin/bash
mongosh -u root -p example

#nginex
kubectl get nodes -o wide
minikube -p practica-creativa service -n ingress-nginx ingress-nginx-controller --url
kubectl describe svc ingress-nginx-controller -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl describe svc ingress-nginx-controller -n ingress-nginx
kubectl port-forward --namespace pc-k8s --address 0.0.0.0 service/flask-svc 5001:5001
minikube -p practica-creativa tunnel

# describe PODS

kubectl describe pod kafka-5b79dd7b94-jph77 -n pc-k8s

# logs

kubectl logs -n pc-k8s -f flask-55f74fd5f9-hx9cb
kubectl logs -n pc-k8s kafka-6896765b47-wjz66
