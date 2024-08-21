## Project on Kubernetes, github actions and load testing

## How I approached the task:
1. Tested http-echo setup in Docker locally
   
   ***Challenges*** : Version issue faced with go, dist and docker image creations

2. Installed and tested kind cluster, deployment of foo and bar, service deployment, ingress deployment

   ***Challenges*** :  In service deployment files, started with LoadBalancer as type, but only portforwarding works with kind

3. Started integrating all the locally tested tasks in GithubActions

   ***Challenges*** :  Locally worked project faced issue with ingress deployment - webhook error. Invalidated the webhook to proceed further. Load test printing and artifacts to download the result was not working and not rendering output as expected


**RESULT** 

Completed the task of setting up kind cluster, accessing foo, bar and generating the summary report with load test details in PR in Github Actions. Tested the same and added the details
   
### 1. Steps to setup at local and test http-echo

     pre-requisites: go (version: 1.21)
                     Docker Desktop up and running
```
    1. git clone https://github.com/hashicorp/http-echo
    2. make clean dist bin docker
    3. docker run -p 5678:5678 http-echo:local
```
       
<img width="300" alt="Screenshot 2024-08-22 at 1 07 48 AM" src="https://github.com/user-attachments/assets/690f59a8-3d1c-49ec-ad8d-c10f240d7147">

### 2. Steps to setup kind at local and application
     pre-requisites: go (version: 1.21)
                     Docker Desktop up and running

```
    1. git clone https://github.com/hashicorp/http-echo
    2. make clean dist bin docker
    3. kind create cluster --config kind-cluster.yaml
    4. kind load docker-image http-echo:local --name kind
    5. kubectl get nodes
    6. kubectl apply -f bar-deployment.yaml
    7. kubectl apply -f foo-deployment.yaml 
    8. kubectl apply -f bar-deployment.yaml 
    9. kubectl apply -f foo-deployment.yaml
    10. kubectl apply -f bar-service.yaml 
    11. kubectl apply -f foo-service.yaml
    12. helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    13. helm repo update
    14. helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
    15. kubectl apply -f ingress.yaml 
    16. kubectl get pods -n ingress-nginx
    17. kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80
```

CLUSTER info
```
priya ~/project/goodnotes/new_repo/githubactions [feature/samplePR] $ kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   36h   v1.26.0
kind-worker          Ready    <none>          36h   v1.26.0
kind-worker2         Ready    <none>          36h   v1.26.0
priya ~/project/goodnotes/new_repo/githubactions [feature/samplePR] $
```


```
priya ~/project/goodnotes/new_repo/githubactions [feature/samplePR] $ kubectl get pods
NAME                   READY   STATUS    RESTARTS      AGE
bar-744c7f4cfd-s5svk   1/1     Running   2 (25h ago)   36h
foo-55447b458b-lx98s   1/1     Running   0             17h
priya ~/project/goodnotes/new_repo/githubactions [feature/samplePR] $
```

Once port-forwarding is done, we can load the foo and bar sites

<img width="380" alt="Screenshot 2024-08-22 at 1 19 48 AM" src="https://github.com/user-attachments/assets/89967f8c-c720-4525-bcdd-ff222efb3749">
<img width="350" alt="Screenshot 2024-08-22 at 1 19 56 AM" src="https://github.com/user-attachments/assets/dc3307e9-2af5-40fd-964d-ac691ce3b579">

### 3. GithubActions integrations in code and PR result here and code zip uploaded as per instruction


Some folder details:
```
 - .github/actions/test.yml - File where all the task integration happened
 - deployment/ - deployment files for foo and bar are kept here
 - services/ - service files for foo and bar are kept here
 - http-echo/ - Based on the repo : [http-echo](https://github.com/hashicorp/http-echo)
 - ingress/ - Ingress traffic routing for foo and bar
 - Scripts/
    -> image.sh         : to create a docker image from http-echo folder
    -> load-test-bar.js : status check as part of load test for the application bar
    -> load-test.js     : status check as part of load test for the application foo
```
