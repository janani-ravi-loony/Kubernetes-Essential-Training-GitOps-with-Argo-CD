
=> Go to github and click on "New"
=> Give repo name "loony-argocd-private-repo" and select "Private" and click on "Create repository"
=> Now we will clone this repo on our local machine
=> Now go to terminal and inside ArgoCD dir clone the git repo by runnning below command:

cd ArgoCD

git init 

git clone https://github.com/loonyuser/loony-argocd-private-repo.git

ls -l

cd loony-argocd-private-repo

=> In this demo we will deploy a app with Flask
=> We will create a dir

mkdir hello_app
cd hello_app
mkdir app 
cd app 

=> We will create a python file 

nano main.py (refer main_v1.py)

=> Save the file and create a requirement file 

nano requirements.txt (refer requirments.txt)

=> Save this file and create a docker file 

nano Dockerfile (refer Dockerfile)

=> Save this and create docker image

docker build -f Dockerfile -t clouduserloony/hello-app:v1 .

=> Show that the image is created

docker image ls 

=> Now go to docker hub (https://hub.docker.com/) and login 
=> Click on Repositories and click on "Create Repository"
=> Give repository name "hello-app" and select private and click on "Create"
=> Now from terminal login to docker and push the image on docker hub

docker login 

=> Use credentials as below:

username: clouduserloony
user-email: cloud.user@loonycorn.com 
password: Witches2019

docker push clouduserloony/hello-app:v1

=> Switch over to the app created on docker hub in the browser and show the new image pushed

=> Now we will create the yaml files but first we have to create secret to access the private image

=> Show the secret 

kubectl get secret 

=> Here we have one secret. we will create one more to access the docker private image

??????
=> Show the docker config file 
=> nano .docker/config.json
??????

=> For docker hub server is "https://index.docker.io/v2/" we will use this to create secret

kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v2/ \
--docker-username=clouduserloony \
--docker-password=password \
--docker-email=cloud.user@loonycorn.com

=> Show secret is created:

kubectl get secret

=> Show the content of secret:

kubectl get secret regcred --output=yaml

=> We will use this secret in deployment yaml file 
=> Create yaml files 

cd ..
nano deployment.yaml (refer deployment_v1.yaml)

=> Save the file and create service yaml 

nano service.yaml 

=> Push the all file to github 

git add .

git status

git commit -m "Hello App"
git push 

=> Once code is pushed go to argocd UI and click on Settings -> Repositories
=> Click on "Connect repo using https"
=> Fill the details as below:

url : https://github.com/loonyuser/loony-argocd-private-repo
username: loonyuser
password: RunLoonycorn0

=> Click on connect and our private repo will be added.
=> Go to terminal and add this repo with the project:

argocd proj add-source loony-argocd https://github.com/loonyuser/loony-argocd-private-repo

=> Go to UI and go to Settings -> Projects
=> Click on loony-argocd project and show this source git is added 
=> Click on "Manage App" icon and click on  "New App" and fill info as below:

Application Name: hello-app
Project: loony-argocd
Repository URL: https://github.com/loonyuser/loony-argocd-private-repo (select from dropdown)
Path: hello_app
Cluster: (Select the cluster that we added from dropdown)
Namespace: default

=> Click on Edit as yaml and we can see the details in yaml form also.

=> Click on create app and sync it.


=> Wait on this page till the syncing is complete

=> On the flowchart click on the deployment pod

= Go to logs and show that you can see the Flask message (usual message you see on the terminal when running locally)


=> Once app is running go to terminal get server:

kubectl config use-context k3d-loony-dev-cluster
kubectl get all

=> Do port forwarding to access server:

kubectl port-forward svc/hello-app-service -n default 8081:6000

=> Go to browser and access the localhost:8081 and here we can see the hello message
=> Stop the port-forwarding using ctrl+C from terminal
=> Now go to terminal and change code in main.py 

nano main.py (refer main_v2.py)

=> Create image and push it to the docker hub

docker build -f Dockerfile -t clouduserloony/hello-app:v2 .
docker push clouduserloony/hello-app:v2

=> Now change the deployment.yaml file (refer deployment_v2.py)
=> Push the file to github 

git add app/main.py 
git add deployment.yaml


git commit -m "Changed image version"
git push 

=> Go to argocd UI and sync the app
=> Once app is synced again do the port forwarding:

kubectl port-forward svc/hello-app-service -n default 8081:6000

=> Go to browser and this we will get a hello message for both localhost:8081 and localhost:8081/argocd 
=> Go to terminal where we did port forwarding for hello app and stop it using ctrl+C
