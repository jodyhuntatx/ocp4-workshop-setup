# Authenticator running as Secretless Broker
# No secrets retrieval in application 

## Lab exercise:
1) Create deployment yaml:

   Run: ```labctl yaml```
2) Cat & study contents of app-secretless-policy.yaml:

   Run: ```cat app-secretless-policy.yaml```
3) Load the DAP policy:

   Run: ```../load_policy.sh root app-secretless-policy.yaml```
4) Cat & study contents of secretless.yaml:

   Run: ```cat secretless.yaml```
5) Create secretless config map:

   Run: ```oc create cm secretless-config --from-file=secretless.yaml```
6) Cat & study contents of app-secretless-manifest.yaml:

   Run: ```cat app-secretless-manifest.yaml```
7) Deploy the app by applying the manifest:

   Run: ```oc apply -f app-secretless-manifest.yaml```
8) Get pod name. Wait until STATUS is "Running"

   Run: ```oc get pods```
9) Get the secretless broker log. What is it doing?

   Run: ```oc logs <pod-name> -c secretless-broker```
10) Exec into pod & run an interactive bash shell:

    Run: ```oc exec -it <pod-name> bash```
11) Cat & study contents of mysql_secretless.sh. How will it connect to the DB w/o creds?:

    Run: ```cat mysql_secretless.sh```
12) Run the script to connect to DB:

    Run: ```./mysql_secretless.sh```
13) Exit the mysql prompt:

    Run: ```exit```
14) Exit the pod:

    Run: ```exit```
15) Delete the deployment & config map:

    Run: ```oc delete -f app-secretless-manifest.yaml```

    Run: ```oc delete cm secretless-config```

## Bonus exercise
TBD

### End of lab
