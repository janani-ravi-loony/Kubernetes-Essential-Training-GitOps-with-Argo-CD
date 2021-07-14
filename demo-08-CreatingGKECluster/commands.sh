
=> From the side navigation menu select Kubernetes  
=> Click on "Create" -> Standard(Configure)
=> Give cluster name and other parameters as belwo:

Name: loony-argocd-cluster
Location Type: Zonal
Zone: us-central1-c
Control plane version: Static Version

=> Once cluster is up and running click on three dots and select Connect
=> Copy the command and paste it in cloud shell and press enter and it will be connected to cluster




=> Show docker version

docker version

=> Show cluster is in docker:

docker ps 

=> Show cluster:

kubectl get nodes -o wide

=> Show namespace:

kubectl get namespace 

=> Create name space

kubectl create namespace argocd

=> Show namespace is created:

kubectl get namespace

=> Add manifest files:

kubectl apply -n argocd \
 -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

=> Show pods, servive and deployments:

kubectl -n argocd get all

=> Some of the things are still in pending state. Wait for some time run  

kubectl -n argocd get all


=> This time everything is running. And Chnage server type to load balancer:

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

=> Go to the Kubernetes cluster page 
=> Click on Services & Ingress
=> Click on the argocd-server details page and show the details of the service
=> Show the server type is changed, it is now LoadBalancer

=> Click on the link of the LoadBalancer on this page and show that the LB has been set up

=> In gcp go to the kubernetes cluster page and click on Services & Ingress from LHS menu

=> Here we will see a argocd-server with type load balancer and status is "Creating Service Endpoints"
=> Wait for sometime and click on refresh
=> Click on the ip address -> Advanced -> Proceed to <IP> (unsafe)
=> We will get the argocd UI
=> From cloud shell run command to get password:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

=> Login app using username admin and password that we got by running above command

