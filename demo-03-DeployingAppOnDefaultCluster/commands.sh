
=> Show that git is already installed on your local machine

git --version

=> Now we will configure the github repo so go to https://github.com 

=> Click on "New" and give repo name "loony-argocd-public-repo" and choose public and click on "Create repository" 

=> Now go to terminal and inside ArgoCD dir clone the git repo by runnning below command:

cd ~/Desktop/ArgoCD

git init 

git clone https://github.com/loonyuser/loony-argocd-public-repo.git

=> Here we will get a warning that we are cloning a empty repo. Show repo is cloned.

ls -l

=> First we will deploy a simple nginx image so lets create yaml files for deployment and service
=> Create a folder nginx_yaml_files inside public repo tha we cloned.

cd loony-argocd-public-repo

mkdir nginx_yaml_files

cd nginx_yaml_files

=> Create yaml files (refer deployment.yaml)

nano deployment.yaml 

=> Save the code and save it. Create service yaml file 

nano service.yaml 

=> Save the file and show we have two yaml files.

ls -l 

=> Push these file to git repo

cd ..
git add .

git status


=> Now commit the code

git commit -m "Uploaded nginx yaml files"
git push

=> This will ask for the user name and password 

username: loonyuser
password RunLoonycorn0

=> Run to show that files have been committed

git status

=> Go to git hub and show the files in the repo.

=> Start the port forwarding from other terminal tab:

kubectl port-forward svc/argocd-server -n argocd 8080:443

=> Go to ArgoCD UI 
=> Click on Settings -> Repositories -> Connect repo using HTTPS 
=> Give type as git and paste the repo url (https://github.com/loonyuser/loony-argocd-public-repo) in repository url and 
here no need to give username and Password because this is public repo 
=> Click on connect 
=> And the git is successfully added
=> Click on 3 dot on RHS and here we can see we have two options for "Create application" and "Disconnect"
=> Click on Manage app icon (above settings) and click on "New App"
=> Fill info as below (rest of the other things we will use as default settings):

# When deploying internally (to the same cluster that Argo CD is running in), https://kubernetes.default.svc should be used as the application's K8s API server address.

Application Name: simple-nginx-server
Project: default (select from dropdown)
Repository URL: https://github.com/loonyuser/loony-argocd-public-repo (select from dropdown)
Path: nginx_yaml_files
Cluster: https://kubernetes.default.svc (Select from dropdown)
Namespace: default 

=> Click on "Create"
=> Click on newly created app and click on "APP DIFF" and show the code that we added from github 
=> Go to terminal and run below command:

kubectl -n default get all

=> Here we will see nothing except one kubernetes service 
=> Now go to argocd UI click on "SYNC" and click on "SYNCHRONIZE" 
=> Once app is synchronized click on each box and show the details

=> Wait till everything is nice and green


=> Now go to terminal and run below command:

kubectl -n default get all

=> This time we will get a nginx service is running 
=> We will use the port forwarding to access the service so run below command:

kubectl port-forward svc/nginx-service -n default 8081:80

=> Go to browser and run http://localhost:8081 
=> Here we can see the nginx welcome page
=> Click on nginx.org and we will be forwarded to the nginx doc page.
=> Go to terminal where we did port forwarding for nginx and stop it using ctrl+C

