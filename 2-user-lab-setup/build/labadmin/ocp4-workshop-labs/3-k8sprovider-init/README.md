# Authenticator running as Secrets Provider for K8s
# Retrieve secrets as K8s secrets

## Lab exercise:
1) Create deployment yaml:

   Run: ```labctl yaml```
2) Cat & study contents of app-k8ssecrets-policy.yaml:

   Run: ```cat app-k8ssecrets-policy.yaml```
3) Load the DAP policy:

   Run: ```../load_policy.sh root app-k8ssecrets-policy.yaml```
4) Cat & study contents of db-credentials.yaml:

   Run: ```cat db-credentials.yaml```
5) Cat & study contents of app-k8ssecrets-manifest.yaml:

   Run: ```cat app-k8ssecrets-manifest.yaml```
6) Deploy the app by applying the manifest:

   Run: ```oc apply -f app-k8ssecrets-manifest.yaml```
7) Get pod name. DO NOT WAIT until STATUS is "Running"

   Run: ```oc get pods```
8) Follow the secrets provider log. Watch it authenticate, retrieve secrets and update the db-credentials secret:

   Run: ```oc logs <pod-name> -c secrets-provider -f```
9) Edit db-credentials, notice base64 encoded values for username and password:

   Run: ```oc edit secret db-credentials```
10) Exec into pod & run an interactive bash shell:

    Run: ```oc exec -it <pod-name> bash```
11) Cat & study contents of mysql_provider.sh:

    Run: ```cat mysql_provider.sh```
12) Run the script to retrieve DB creds and connect to DB:

    Run: ```./mysql_provider.sh```
13) Exit the mysql prompt:

    Run: ```exit```
13) Exit the pod:

    Run: ```exit```
14) Delete the deployment & secret:

    Run: ```oc delete -f app-k8ssecrets-manifest.yaml```

    Run: ```oc delete -manifest.yaml```

## Bonus exercise:
1) Edit k8s-secrets.yaml - change the name of secret retrieved for password
2) ```oc apply -f app-k8ssecrets-manifest.yaml```
3) ```oc get pods```
4) ```oc logs <pod-name> -c secrets-provider -f```
5) What is happening in the pod log? Why?
6) ```oc delete -f app-k8ssecrets-manifest.yaml```
7) ```oc delete -manifest.yaml```

### End of lab
