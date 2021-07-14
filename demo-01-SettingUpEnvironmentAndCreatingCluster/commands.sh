=> Assume that they already have Docker installed and running

=> Again go to terminal and show docker version:

docker version

=> Run below command and show nothing is there in container:

docker container ls

=> Install kubectl by running below command:

brew install kubectl

=> Install k3d using below command:

brew install k3d

=> Show version of k3d:

k3d version

=> On Desktop create a folder "ArgoCD" 

cd Desktop

mkdir ArgoCD

ls -l 

cd ArgoCD

=> Create a config file for cluster:

nano cluster-config.yaml (Refer cluster-config.yaml)

=> Save the file and create cluster using k3d command:

k3d cluster create argocd-cluster --config ./cluster-config.yaml

=> Open docker and go to containers and show cluster is created

=> Open up docker right away and show all the red becoming green


=> Show cluster is created with one master node and two worker nodes:

docker ps

kubectl get nodes

kubectl get nodes -o wide

=> Open kubeconfig file and show configuration:

nano ~/.kube/config 

=> Close the file using ctrl+X
