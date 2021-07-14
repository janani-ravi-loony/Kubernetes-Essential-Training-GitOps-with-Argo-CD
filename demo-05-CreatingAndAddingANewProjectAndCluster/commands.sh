
=> In last module we worked with default project and internal cluster. 
In this module we will create a project and worked with external cluster So first login the UI.
=> Find the ip address of our local machine:

IP=`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}'` && echo $IP

=> Copy this ip address and create a new yaml file in ArgoCD folder "dev-cluster-config.yaml" with this ip address

#  A SAN or subject alternative name is a structured way to indicate all of the domain names and IP addresses that are secured by the certificate

=> Create a new cluster using this yaml file 

k3d cluster create loony-dev-cluster --config ./dev-cluster-config.yaml

=> Show cluster is created:

kubectl cluster-info

=> Open kube/config file and replace 0.0.0.0 with pur ip address

nano ~/.kube/config

=> Save file and run 

kubectl version

=> This should not throw any error
=> Show cluster list 

kubectl config get-contexts -o name


=> Change context 

kubectl config use-context k3d-argocd-cluster

=> Make sure you have port forwarding on

kubectl port-forward svc/argocd-server -n argocd 8080:443

=> Add this new cluster to ArgoCD

argocd cluster add k3d-loony-dev-cluster --name dev-cluster


=> Login to argocd from terminal

argocd login localhost:8080 --insecure

=> Give username "admin" and give the password (the updated one)
=> Show the project list

argocd proj list

=> Show repo list

argocd repo list

=> Show app list

argocd app list

=> Open kube/config file and copy the cluster address for k3d-loony-dev-cluster ( as https://192.168.0.150:51033):


# Projects provide a logical grouping of applications, which is useful when Argo CD is used by multiple teams. Projects provide the following features:

# restrict what may be deployed (trusted Git source repositories)
# restrict where apps may be deployed to (destination clusters and namespaces)
# restrict what kinds of objects may or may not be deployed (e.g. RBAC, CRDs, DaemonSets, NetworkPolicy etc...)
# defining project roles to provide application RBAC (bound to OIDC groups and/or JWT tokens)

=> Create project "loony-argocd" with namespace "default"

argocd proj create loony-argocd -d https://192.168.0.100:51099,default -s https://github.com/loonyuser/loony-argocd-public-repo

=> Show show project is created 

argocd proj list

=> Login UI and show the newly created project is present in Settings -> Projects


=> Also show the new cluster is added in Settings -> Clusters

