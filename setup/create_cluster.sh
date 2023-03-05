#!/bin/bash

# Create Cluster

# Source Bash Config and Utilities
source $SRE/automation/load_bash_config_and_utilities.sh

# Validate the search phrase
if [ -z "$1" ]; then
    e_error "Project ID is mandatory."
    e_warning "Please provide the necessary input and try again."
    e_error "Exiting now..."
    echo
    exit 1
fi

# Initialize the counter
count=1

e_bold "$count) Declare Variables..."
# Declare variables
project_id=$1 #Project ID from the argument
image=COS_CONTAINERD
cluster_name=sre
cluster_version="1.24.9-gke.3200"
region=us-central1
zone=us-central1-c
machine_type=n1-standard-2
num_nodes=8
disk_size=60
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Enable Kubernetes Engine API..."
gcloud services enable container.googleapis.com
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Create GKE Cluster..."
gcloud beta container --project $project_id clusters create $cluster_name --zone $zone --no-enable-basic-auth --cluster-version $cluster_version --release-channel "regular" --machine-type $machine_type --image-type $image --disk-type "pd-balanced" --disk-size $disk_size --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes $num_nodes --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$project_id/global/networks/default" --subnetwork "projects/$project_id/regions/$region/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver,ConfigConnector --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --labels provisioned_by=gcloud --workload-pool "$project_id.svc.id.goog" --enable-shielded-nodes --node-locations $zone --enable-managed-prometheus
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Connect to the GKE Cluster $cluster_name..."
gcloud container clusters get-credentials $cluster_name --zone $zone --project $project_id
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Create Namespaces..."

for ns in {mathgarage,sample,monitoring,ingress-space}
do 
    e_note "    Creating Namespace $ns..."
    kubectl create namespace $ns
    check_previous_command_status
    kubectl label namespace $ns istio-injection=enabled
    check_previous_command_status
done

e_bold "Cluster $cluster_name created successfully."