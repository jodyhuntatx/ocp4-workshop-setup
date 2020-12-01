# Authenticator running as Sidecar Container
# Retrieve secrets with REST API

## Lab exercise:
1) Create deployment yaml:

   Run: ```labctl yaml```
2) Cat & study contents of dap-config-cm.yaml:

   Run: ```cat dap-config-cm.yaml```
3) Create the dap-config config map:

   Run: ```oc apply -f dap-config-cm.yaml```
4) Cat & study contents of app-sidecar-policy.yaml:

   Run: ```cat app-sidecar-policy.yaml```
5) Load the DAP policy:

   Run: ```../load_policy.sh root app-sidecar-policy.yaml```
6) Cat & study contents of app-sidecar-manifest.yaml:

   Run: ```cat app-sidecar-manifest.yaml```
7) Deploy the app by applying the manifest:

   Run: ```oc apply -f app-sidecar-manifest.yaml```
8) Get pod name. Repeat until STATUS is "Running"

   Run: ```oc get pods```
9) Exec into pod & run an interactive bash shell:

   Run: ```oc exec -it <pod-name> bash```
10) Cat & study contents of mysql_REST.sh:

    Run: ```cat mysql_REST.sh```
11) Run the script to retrieve DB creds and connect to DB:

    Run: ```./mysql_REST.sh```
12) exit pod:

    Run: ```exit```
13) Delete the deployment:

    Run: ```oc delete -f app-sidecar-manifest.yaml```

## Bonus exercise:
1) Edit app-sidecar-manifest.yaml
2) Change the value of CONJUR_AUTHN_LOGIN to the host identity of another user (just change the user number to a different value)
3) ```oc apply -f app-sidecar-manifest.yaml```
4) ```oc get pods```

   Note: Get pod name but DO NOT wait until STATUS is "Running"
5) ``` oc logs <pod-name> -c authenticator -f```
6) What is happening? Why?
7) exit pod
8) ```oc delete -f app-sidecar-manifest.yaml```

### End of lab
