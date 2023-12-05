#!/bin/bash

# 1. Create Namespaces
# 1. Deploy Apps

# SAMPLE Namespace:
#   1. hello-world-api.yaml
#   2. gke-template.yaml
#   3. add-api.yaml
#   4. multiply-api.yaml
# MATHGARAGE Namespace
#   1. mathfunctions-api.yaml
#   2. numberwiki-api.yaml
# MONITORING Namespace:
#   1. prometheus.yaml
#   2. grafana.yaml
# INGRESS-SPACE Namespace:
#   1. gateway.yaml

# Source Bash Config and Utilities
source $SRE/automation/load_bash_config_and_utilities.sh

# Create Namespaces
kubectl apply -f ../yamls/ns/ns.yaml
check_previous_command_status

# Initialize the counter
count=0

# Iterate through all the yaml config files in gke/yamls/apps folder
for file in $(ls ../yamls/apps); 
do 
    let "count++" # Increment the counter
    e_bold "$count) Deploying $file..."
    kubectl apply -f $file; 
    check_previous_command_status
    e_success "Deployed $file successfully."
    echo # Blank Line
done

e_bold "$count apps deployed successfully. See deployment details below."
echo # Blank Line

# Initialize the counter
count=0
for ns in {mathgarage,sample,monitoring}
do
    let "count++" # Increment the counter
    e_bold "$count) Namespace $ns:"
    kubectl get deployments -n $ns
    check_previous_command_status
done 

# Fetching Ingress-Gateway separately, as need to fetch GATEWAY resource, not DEPLOYMENT
ns="ingress-space"
let "count++" # Increment the counter
e_bold "$count) Namespace $ns:"
kubectl get gateway -n $ns
echo # Blank Line
check_previous_command_status

e_bold "Process completed."