# Authenticator container running as Init Container 
# Retrieve secrets with Summon

## Lab exercise:
1) Create deployment yaml:

   Run: ```labctl yaml```
2) Cat & study contents of app-init-policy.yaml - compare to the sidecar policy

   Run: ```cat ./app-init-policy.yaml```

   Run: ```sdiff -s ./app-init-policy.yaml ../1-sidecar/app-sidecar-policy.yaml```
3) Load the DAP policy:

   Run: ```../load_policy.sh root app-init-policy.yaml```
4) Cat & study contents of app-init-manifest.yaml - compare to the sidecar manifest:

   Run: ```cat ./app-init-manifest.yaml```

   Run: ```sdiff -s ./app-init-manifest.yaml ../1-sidecar/app-sidecar-manifest.yaml```
5) Deploy the app by applying the manifest:

   Run: ```oc apply -f app-init-manifest.yaml```
6) Get pod name. Repeat until STATUS is "Running"

   Run: ```oc get pods```
7) Exec into pod & run an interactive bash shell:

   Run: ```oc exec -it <pod-name> bash```
8) Cat & study contents of secrets.yml and mysql_summon.sh:

   Run: ```cat secrets.yml```

   Run: ```cat mysql_summon.sh```

9) Run the script to inject DB creds as env vars and connect to DB:

    Run: ```summon ./mysql_summon.sh```
10) exit the mysql prompt:

    Run: ```exit```
11) exit pod:

    Run: ```exit```
12) Delete the deployment:

    Run: ```oc delete -f app-init-manifest.yaml```

## Bonus exercise:
add second secrets.yml w/ env

### End of lab
