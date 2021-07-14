
=> List the namespace that is already present by default:

kubectl get namespace

=> Here we can see "default" namespace also.

# https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
=> Now create argocd namespace by running below command:

kubectl create namespace argocd 

=> Show namespace is created:

kubectl get namespace

=> Open up https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
=>Show the contents

# This is a manifest of the kind CustomResourceDefinition
# ArogCD Application == A group of Kubernetes resources as defined by a manifest. This is a Custom Resource Definition (CRD).

=> Add the default manifest yaml file with argocd namespace:

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

=> Show the service and deployment

kubectl -n argocd get deployment 
kubectl -n argocd get service

# Argo CD is implemented as a kubernetes controller which continuously monitors running applications and compares 
# the current, live state against the desired target state (as specified in the Git repo).
kubectl -n argocd get statefulset

=> Download ArgoCD CLI:
# For other platforms
# https://argo-cd.readthedocs.io/en/stable/cli_installation/

brew install argocd 

=> Show version:

argocd version 

=> This will show version but in last there will be a error for argocd server This is because by default the argocd api server is not exposed with an external IP

=>Run below command for version:

argocd version --client

=> And this time we will not any server related error 
=> Show all things that we set (server, pod, deployment and replicaset)

kubectl -n argocd get all

=> If everything is not in ready status then wait for sometime and run again:

kubectl -n argocd get all

=> Now if everything is in ready state then go ahead
=> Here we can see the argocd-server type id ClusterIP. We will change it to NodePort:

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

=> Again show the argocd server and this time we can see the type changed from ClusterIP to NodePort:

kubectl -n argocd get services

=> Now we will use port-forwarding to connect to API Server without exposing the service:

kubectl port-forward svc/argocd-server -n argocd 8080:443

=> Now open browser and go to http://localhost:8080
=> This will be some warning as "Your connection is not private"
=> Click on "Advanced" and then "Proceed to localhost (unsafe)"
=> And here we will get the argocd UI
=> Open one more tab for terminal and we will run below command to get password:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

=> Here we will get the password
=> Go to UI and give user name as "admin" and paste the password that we copied
=> Click on Sign in and we here we can explore the UI
=> Move cursor to the argocd icon and we can see the argocd version and it is same as we checked in terminal

=> Click on Setting icon and explore repositories, clusters, project and accounts

