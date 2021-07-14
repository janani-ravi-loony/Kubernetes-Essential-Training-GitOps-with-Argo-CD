
=> Go to the loony-argocd-private-repo folder and create the flask app 

cd loony-argocd-private-repo

mkdir summer_trip
cd summer_trip

mkdir app 
cd app

nano Dockerfile

nano main.py

nano requirements.txt

mkdir template
cd template

nano form.html

=> Build image and upload to gcloud container 

cd ..
echo $GOOGLE_CLOUD_PROJECT
docker build -f Dockerfile -t summer-trip:v1 .

=> Show image is created

docker image ls 

=> Change the image 

docker tag summer-trip:v1 gcr.io/$GOOGLE_CLOUD_PROJECT/summer-trip:v1
docker image ls

=> Push the image to container registry

docker push gcr.io/$GOOGLE_CLOUD_PROJECT/summer-trip:v1

=> Go to Container Registry -> Images from side navigation menu and show that the image is pushed and it is private

=> Now we will create the deployment and service yaml files

=> To access the private image first we have to make secret
=> Before that we have to create a service account 

=> From navigation menu go to IAM&Admin -> service accounts

=> Click on create service account 
=> Give service account name "loony-argocd-service"
=> No need to fill other things and click on create 
=> Give "Viewer" role and create the account

=> Once account is created click on the account 
=> Go to "Keys" tab
=> Click on "Add Key" -> "Create new key"
=> This will download a json key 


=> Go to the home directory

cd ~

=> Upload this json key by clicking on the 3 dots in cloud shell 
=> Click on "Upload file" and from Downloads on local machine upload the json file.
=> Show file is uploaded:

ls -l 

=> Show the secret present by default 

kubectl get secret 

=> Here we have one secret. we will create one more to access the docker private image
=> We will created secret (replace the json key and service account, in it case it was as below)

kubectl create secret docker-registry regcred \
--docker-server=gcr.io \
--docker-username=_json_key \
--docker-password="$(cat ~/loony-gcp-project-0b73b80ad2ed.json)" \
--docker-email=loony-argocd-service-646@loony-gcp-project.iam.gserviceaccount.com


=> Show secret is create:

kubectl get secret

=> Show the content of secret:

kubectl get secret regcred --output=yaml

=> Patch this secret 

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "regcred"}]}'

=> We will use this secret in deployment yaml file 

cd loony-argocd-private-repo/summer_trip/


=> Create deployment yaml file with secret:

nano deployment.yaml

=> Save the file and create service.yaml file:

nano service.yaml

=> Now push the code to git repo 

git add .
git status

=> Commit the code 

git commit -m "Created summer trip form"

git push 

=> Go to github and show code is uploaded 
=> Now we will connect this repo with argocd using ssh
=> In the argocd UI click on Settings -> Repository and click on Connect Repo with SSH 
=> Give info as follows

name: loony-argocd-private-repo
ssh url : git@github.com:loonyuser/loony-argocd-private-repo.git

=> Go to Cloud Shell and run

cat .ssh/id_rsa

=> Go back to ArgoCD UI

ssh-key: paste the ssh key that we generated in cloud shell

=> Click on Connect 
=> Now we will create app so click on "New App"
=> This time we will fill info as yaml so click on yaml
=> Fill the info as below

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: summer-trip-app
spec:
  destination:
    name: ''
    namespace: default
    server: 'https://kubernetes.default.svc'
  source:
    path: summer_trip
    repoURL: 'git@github.com:loonyuser/loony-argocd-private-repo.git'
    targetRevision: HEAD
  project: default

=> Click on create 
=> Once app is created click on it and this is not synced click on "App Diff" and show code
=> Click on Sync 
=> Once app is synced and status is healthy 

=> Go to the Kubernetes page on the web browser

=> Click on Workloads
=> Show that there is summer-trip-deployment

=> Go to Serices & Ingress
=> Here we can see a service summer-trip-service and external ip and port
=> Click on external link and here we can see our html page









