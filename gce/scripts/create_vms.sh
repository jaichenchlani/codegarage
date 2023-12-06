#!/bin/bash

# Stage 4 | Complete automation using bash scripts
Create the VMs 

# Source Bash Config and Utilities
source /home/repos/utilities/load_bash_config_and_utilities.sh

echo "***** Create VMs START *****"

# Initialize the counter
count=0

let "count++" # Create webserver Apache on Centos
echo "$count) Create webserver Apache on Centos..."
source create_vm_webserver_apache_centos7.sh

let "count++" # Create webserver Apache on Debian
echo "$count) Create webserver Apache on Debian..."
source create_vm_webserver_apache_debian11.sh

let "count++" # Create webserver Grafana
echo "$count) Create websesrver Grafana..."
source create_vm_webserver_grafana.sh

let "count++" # Create Bastion Host SRE Terminal
echo "$count) Create Bastion Host sreterminal..."
source create_vm_sreterminal.sh

echo "***** Create VMs END *****"