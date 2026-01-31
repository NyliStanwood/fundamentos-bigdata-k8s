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
