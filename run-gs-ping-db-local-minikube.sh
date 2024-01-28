# Source: 
# https://github.com/docker/docker-gs-ping-dev
# https://minikube.sigs.k8s.io/docs/tutorials/kubernetes_101/module1/

# Start minikube
minikube start
minikube dashboard # open new terminal..
# pre-requisit! kubectl config current-context -> minikube
minikube addons enable metrics-server

# Set docker env
#eval $(minikube docker-env)             # Unix shells
#minikube docker-env | Invoke-Expression # PowerShell

# Build image in mc
minikube image build -t gs-ping-db .
minikube image ls

# Deploy (using local image: gs-ping-db ..)
kubectl apply -f ./go-kubernetes.yaml 
kubectl get pods -o wide
kubectl get deployments
kubectl get services

# Connect to Service: server
minikube service server --url
# -> http://127.0.0.1:XXXXX
# open new terminal..

# Test
curl --request POST \
  --url http://localhost:XXXXX/send \
  --header 'content-type: application/json' \
  --data '{"value": "$DB_MSG"}'
curl localhost:XXXXX

# Update application!
sed -i '' 's/Hello, Docker/Hello, Docker2/g' main.go
minikube image build -t gs-ping-db:v3 .
kubectl set image deployments/server server=docker.io/library/gs-ping-db:v3
SERVER_RS=`kubectl get -n default replicaset | grep server | awk '{print $1;}'`
kubectl delete -n default replicaset $SERVER_RS

## FIND BETTER THAN ABOVE.. TEST BELOW?!
kubectl rollout restart deployment/server -n default

# Shutdown and delete
minikube stop
minikube delete --all









#### OLD TESTS (24.01.28)...



# -> EXPOSE 8080

# Run in Minikube
kubectl run gs-ping-db --image=docker.io/library/gs-ping-db --image-pull-policy=Never

# Check that it's running
kubectl get pods
# ->    NAME      READY   STATUS    RESTARTS   AGE
# ->    gs-ping   1/1     Running   0          14s

kubectl logs gs-ping-db

kubectl create deployment gs-ping-db --image=docker.io/library/gs-ping-db
kubectl get deployments

kubectl expose deployment server --type=LoadBalancer --port=7070
kubectl get services
# -> NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
# -> gs-ping      LoadBalancer   10.108.65.212   <pending>     8080:32446/TCP   23s
# minikube service gs-ping
# -> Starting tunnel for service gs-ping.
# | NAMESPACE |  NAME   | TARGET PORT |          URL           |
# |-----------|---------|-------------|------------------------|
# | default   | gs-ping |             | http://127.0.0.1:56186 |

# -> SUCCESS! gs-ping available through browser!
# -> SUCCESS! curl http://127.0.0.1:56186/

# OR use
kubectl port-forward gs-ping-db 9090:8080
# -> Forwarding from 127.0.0.1:9090 -> 8080
curl localhost:9090
# -> SUCCESS!



# Stop, clean
minikube stop
minikube delete --all


# Port forward
# In Docker: docker run --publish 8080:8080 gs-ping:v1
# In minikube: 
## kubectl create deployment gs-ping --image=gs-ping:v1
## kubectl expose deployment gs-ping-deployment --type=NodePort --port=7080



