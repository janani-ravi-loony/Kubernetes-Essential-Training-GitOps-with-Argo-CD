
=> Make sure you have removed the previously existing loony-argocd-private-repo directory (do not need to show in the recording)


=> Login to gcp https://console.cloud.google.com/

=> Go to Api&Services and enable the below apis:

Kubernetes Engine API
Google Container Registry API

=> Open up Cloud Shell

=> Make it full screen on a new tab

=> We are using loony-gcp-project. so config it.

gcloud config set project loony-gcp-project

=> Create the ssh key. This ssh key we will use to clone the github repo loony-argocd-private-repo
=> Need to remove the old keys first

rm -rf .ssh 

ssh-keygen

=> Press enter for every value and our key will be created 
=> Go to .ssh dir and show key is created

cd .ssh
ls -l 

cat id_rsa.pub

=> Copy the key


=> Login to github and go to the loony-argocd-public-repo and click on loonyuser icon (on upper right side) -> "Settings"
=> Click on SSH and GPG keys 
=> Write title "ssh-key"
=> Paste the ssh-key that we generated
=> Click on add ssh key and write password to confirm
=> Now go to repo and click on "Code" -> "SSH"
=> Copy the ssh and go to cloud shell
=> Run below command:

git init 

git clone git@github.com:loonyuser/loony-argocd-public-repo.git

=> Show we cloned the repo 

ls -l


################################################## demo-09-CreatingGKECluster #################################################################

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

