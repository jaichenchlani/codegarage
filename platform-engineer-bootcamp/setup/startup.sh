#!/bin/bash

# Startup script for a new GCP Project

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
region=us-central1
zone=us-central1-c
machine_type=e2-medium
ksa=ksa-monitoring # Kubernetes Service Account
gsa=gsa-monitoring # IAM Service Account
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Enable Kubernetes Engine API..."
gcloud services enable container.googleapis.com
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Create GKE Cluster..."
# gcloud beta container --project $project_id clusters create $cluster_name --zone $zone --no-enable-basic-auth --cluster-version "1.24.8-gke.2000" --release-channel "regular" --machine-type $machine_type --image-type $image --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$project_id/global/networks/default" --subnetwork "projects/$project_id/regions/$region/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver,ConfigConnector --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --labels provisioned_by=gcloud --workload-pool "$project_id.svc.id.goog" --enable-shielded-nodes --node-locations $zone --enable-managed-prometheus
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Connect to the GKE Cluster $cluster_name..."
gcloud container clusters get-credentials $cluster_name --zone $zone --project $project_id
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Create Namespaces..."
# kubectl create namespace mathgarage
# check_previous_command_status
# kubectl create namespace sample
# check_previous_command_status
# kubectl create namespace monitoring
# check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Setup Workload Identity..."

e_bold "    A. Create IAM Service Account..."
gcloud iam service-accounts create $gsa --project=$project_id

role1=roles/monitoring.viewer
role2=roles/bigquery.user
role3=roles/bigquery.dataViewer

e_bold "    B. Assign the following roles to the IAM Service Account $gsa."
e_note "    $role1"
e_note "    $role2"
e_note "    $role3"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role1
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role2
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role3

e_bold "    C. Create Kubernetes Service Account..."
kubectl create serviceaccount $ksa

e_bold "    D. Allow the Kubernetes service account to impersonate the IAM service account by adding an IAM policy binding between the two service accounts. This binding allows the Kubernetes service account to act as the IAM service account."
gcloud iam service-accounts add-iam-policy-binding $gsa@$project_id.iam.gserviceaccount.com --role roles/iam.workloadIdentityUser --member "serviceAccount:$project_id.svc.id.goog[monitoring/$ksa]"

e_bold "    E. Annotate the Kubernetes service account $ksa with the email address of the IAM service account i.e. $gsa."
kubectl annotate serviceaccount $ksa --namespace monitoring iam.gke.io/gcp-service-account=$gsa@$project_id.iam.gserviceaccount.com

let "count++" # Increment the counter
e_bold "$count) Deploy Apps..."
kubectl apply -f ../gke-deploy
check_previous_command_status

# let "count++" # Increment the counter
# e_bold "$count) Get the external ips of all the mathgarage and sample namespace services..."
# for ns in {"mathgarage","sample"}; do kubectl get svc -n $ns --no-headers | awk '{printf "host-%s=%s\n", $1,$4}' ; done

# let "count++" # Increment the counter
# e_bold "$count) Run the test..."
# e_bold "Replace the above information in $PACAKAGE/automation/test_apps/run_test.sh
# e_warning "This is still a manual step.. so sorry.."

e_bold "Startup Script completed."