## Initialize a new GCP Free Tier Account
Steps below outline the initialization process for a new GCP Free Tier Account

### Instructions
1. Create a new account with jaichenchlanigcpuser<n>@gmail.com
2. Use project of your choice - either "My First Project" or create your own.
3. gcloud config
    - `gcloud config configurations create gcpuser<9>`
    - `gcloud config configurations activate gcpuser<9>`
    - `gcloud auth login`
4. Enable billing
    - Enable billing export to BigQuery. You will be required to create a new dataset during the process.
    - Use the query below in BigQuery to view your billing details. Replace the dataset/table name with yours.
    ```SELECT project.name as project, service.description as resource, round(sum(cost)) as cost
    FROM `codegarage-377302.billing.gcp_billing_export_v1_0180BE_F4324C_CAFD43` 
    GROUP BY project, resource
    ORDER BY cost DESC```
5. Setup
    - Review the ***Declare Variables*** in each script, and ensure that you are purposeful about the values declared.
    - Run `./create_cluster.sh $project_id`
        1. Enable Kubernetes Engine API
        2. Create Kubernetes Cluster
        3. Connect to the cluster
        4. Create the 4 namespaces - mathgarage, sample, monitoring and ingress-space with labels istio-injection=enabled.
    - Install Istio `/Users/jai/mydata/technical/asm/istio-1.16.2-asm.2/bin/istioctl` **manual**
    - Run `./setup_workload_identity.sh $project_id` to setup Workload Identity
    - Deploy Apps
        1. ***Review the grafana and prometheus yamls for the correct service accounts and project id. If this is not accurate, you will run into 403 forbidden issues. ***
        2. Run `./deploy_apps.sh` to deploy all the demo apps 
6. Validate all the workloads and services are up and running.
7. Setup Grafana
    1. Add Data Sources
        - Prometheus : http://<external-ip>:80
        - Google Cloud Monitoring: Use JWT of the gsa-monitoring service account
    2. Import [gke_customized_dashboard_codegarage](../observability/gke_customized_dashboard_codegarage.json)
8. Run Load Test Automation to induce traffic.
9 Validate traffic showing up on the Grafana Dashboard. 