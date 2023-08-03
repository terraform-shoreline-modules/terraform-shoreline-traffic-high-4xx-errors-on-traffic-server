
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High 4xx Errors on Traffic Server
---

This incident type occurs when the number of 4xx errors on Traffic Server is at an anomalous level, higher than usual. It could be an indicator of an issue with the server or an increase in traffic that is causing errors. It requires investigation and resolution to ensure the server is functioning correctly and not impacting users.

### Parameters
```shell
# Environment Variables

export POD_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export PATH_TO_CONFIG_FILE="PLACEHOLDER"

```

## Debug

### Check if the affected pod is running
```shell
kubectl get pods -n ${NAMESPACE} | grep ${POD_NAME}
```

### Check the logs of the pod for any relevant error messages
```shell
kubectl logs ${POD_NAME} -n ${NAMESPACE}
```

### Check the status of the deployment
```shell
kubectl describe deployment ${DEPLOYMENT_NAME} -n ${NAMESPACE}
```

### Check the status of the service
```shell
kubectl describe service ${SERVICE_NAME} -n ${NAMESPACE}
```

### Check the logs of the Traffic Server container
```shell
kubectl logs ${POD_NAME} -c ${CONTAINER_NAME} -n ${NAMESPACE}
```

### Check the number of 4xx errors in the last 15 minutes
```shell
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -n ${NAMESPACE} -- curl -s http://localhost:8000/stats | grep '4xx'
```

### Check the configuration file for Traffic Server
```shell
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -n ${NAMESPACE} -- cat ${PATH_TO_CONFIG_FILE}
```

## Repair

### Set the namespace where Traffic Server is deployed
```shell
NAMESPACE=${NAMESPACE}
```

### Set the name of the Traffic Server pod
```shell
POD_NAME=${POD_NAME}
```

### Set the name of the Traffic Server container
```shell
CONTAINER_NAME=${CONTAINER_NAME}
```

### Set the path to the Traffic Server log file
```shell
LOG_FILE=${LOG_FILE}
```

### Get the logs from the Traffic Server pod and container
```shell
kubectl logs $POD_NAME -n $NAMESPACE -c $CONTAINER_NAME > /tmp/application.log
```

### Search for 4xx errors in the log file
```shell
grep " 4[0-9][0-9] " /tmp/application.log
```

### Check the exit code of the grep command to see if any 4xx errors were found
```shell
if [ $? -eq 0 ]

then

    echo "4xx errors found in the log file"

else

    echo "No 4xx errors found in the log file"

fi
```

### Increase the server capacity to handle the increased traffic, if applicable.
```shell


#!/bin/bash



# Set variables

DEPLOYMENT_NAME=${DEPLOYMENT_NAME}

NAMESPACE=${NAMESPACE}

REPLICAS="PLACEHOLDER"



# Scale up the deployment

kubectl scale deployment $DEPLOYMENT_NAME --namespace $NAMESPACE --replicas $REPLICAS


```

### Optimize the Traffic Server configuration to improve performance and reduce the number of 4xx errors.
```shell
bash

#!/bin/bash



# Set the Kubernetes namespace and the Traffic Server deployment name

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT}



# Get the current Traffic Server configuration

CURRENT_CONFIG=$(kubectl get configmap -n $NAMESPACE $DEPLOYMENT -o json | jq -r '.data.traffic_server_config')



# Modify the configuration to optimize performance

NEW_CONFIG=$(echo $CURRENT_CONFIG | sed 's/CONFIG_OPTION1=.*$/CONFIG_OPTION1=new_value/')

NEW_CONFIG=$(echo $NEW_CONFIG | sed 's/CONFIG_OPTION2=.*$/CONFIG_OPTION2=new_value/')



# Update the Traffic Server configuration

kubectl patch configmap -n $NAMESPACE $DEPLOYMENT --type merge -p "{\"data\":{\"traffic_server_config\":\"$NEW_CONFIG\"}}"



# Restart the Traffic Server deployment to apply the new configuration

kubectl rollout restart deployment -n $NAMESPACE $DEPLOYMENT


```