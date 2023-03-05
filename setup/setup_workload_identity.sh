#!/bin/bash

# Setup Workload Identity for Grafana and Prometheus

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
cluster_name=sre
ksa=ksa-monitoring4 # Kubernetes Service Account
gsa=gsa-monitoring4 # IAM Service Account
check_previous_command_status

let "count++" # Increment the counter
e_bold "$count) Setup Workload Identity..."

e_bold "    A. Create IAM Service Account..."
gcloud iam service-accounts create $gsa --project=$project_id
check_previous_command_status

role1=roles/monitoring.viewer
role2=roles/bigquery.user
role3=roles/bigquery.dataViewer
role4=roles/iam.serviceAccountTokenCreator

e_bold "    B. Assign the following roles to the IAM Service Account $gsa."
e_note "    $role1"
e_note "    $role2"
e_note "    $role3"
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role1
check_previous_command_status
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role2
check_previous_command_status
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role3
check_previous_command_status
gcloud projects add-iam-policy-binding $project_id --member serviceAccount:$gsa@$project_id.iam.gserviceaccount.com --role $role4
check_previous_command_status

e_bold "    C. Create Kubernetes Service Account in monitoring namespace..."
kubectl create serviceaccount $ksa -n monitoring
check_previous_command_status

e_bold "    D. Allow the Kubernetes service account to impersonate the IAM service account by adding an IAM policy binding between the two service accounts. This binding allows the Kubernetes service account to act as the IAM service account."
gcloud iam service-accounts add-iam-policy-binding $gsa@$project_id.iam.gserviceaccount.com --role roles/iam.workloadIdentityUser --member "serviceAccount:$project_id.svc.id.goog[monitoring/$ksa]"
check_previous_command_status

e_bold "    E. Annotate the Kubernetes service account $ksa with the email address of the IAM service account i.e. $gsa."
kubectl annotate serviceaccount $ksa --namespace monitoring iam.gke.io/gcp-service-account=$gsa@$project_id.iam.gserviceaccount.com
check_previous_command_status

e_bold "Workload Identity Setup completed."