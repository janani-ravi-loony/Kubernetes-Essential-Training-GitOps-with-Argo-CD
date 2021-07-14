
=> Run below command and get the password:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

=> Copy the password and login the UI using below command:

argocd login localhost:8080

=> Enter y and then give username "admin" and paste the password that we copied
=> Once we are login successfully update the password. For that run :

argocd account update-password

=> Paste the old password 
=> Enter new password 
=> Enter the new password again to confirm and our password will be updated successfully.

=> Go to browser and logout from the argocd UI and login again with new password
=> Give user name "admin" and enter the new password and we will be logged in successfully


=> Here we can see the app that we deployed in last demo.

=> In the terminal window run this

kubectl -n default get replicaset

kubectl get all

=> In our terminal open deployment.yaml file and change replica to 2

cd nginx_yaml_files
nano deployment.yaml (refer deployment.yaml)

=> Save the file and push to github

cd ..
git add nginx_yaml_files/deployment.yaml 
git commit -m "Updated number of replicas"
git push

=> Go to github and show the deployment.yaml files 
=> Go to argocd UI and click on "REFRESH" and we will see that app is out of sync.

=> Go to "APP DIFF" and show the difference

=> Click on "SYNC" and we can see one more replica is created
=> once app is synced go to terminal and run:


kubectl -n default get all
kubectl -n default get replicaset


=> Here we can see the number of pods is 2 
=> Now change relica from terminal by running below command:

kubectl scale deploy nginx-deployment --replicas 3
kubectl get all

=> Here we will see one more replica is in creating state
=> If we go to UI, there the app will go out of sync
=> Click on "nginx-deployment"
=> Click on "APP DIFF" and select "Compact diff" here we can see that in github code we have set replica to 2 but from terminal we set to 3 
=> If we click on "SYNC" in UI it will terminate the extra replica.
=> We can see it in UI as well as in terminal if we will run :

kubectl -n default get all

=> Here we can see the replica is terminating

# https://argoproj.github.io/argo-cd/user-guide/auto_sync/

=> Now click on app details and click on "ENABLE AUTO-SYNC" and select "OK"
=> Enable "Prune Resource" and "Self Heal"
=> Now from terminal againg scale the replica :

kubectl scale deploy nginx-deployment --replicas 3

kubectl -n default get all

=> Now go to UI and click on refresh we can see the app will auto sync, create the replica and then terminate it.
=> Now from terminal againg change the deployment.yaml file and set replica to 1 and push the code 

cd nginx_yaml_files
nano deployment.yaml
cd .. 
git add nginx_yaml_files/deployment.yaml
git commit -m "Set replica back to 1"
git push






