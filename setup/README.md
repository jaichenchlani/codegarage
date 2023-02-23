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
5. Run the Start Script - pass project_id as argument.
`./startup.sh $project_id`
    1. Enable Kubernetes Engine API
    2. Create Kubernetes Cluster
    3. Connect to the cluster
    4. Create the 3 namespaces - mathgarage, sample and monitoring
    5. Deploy Apps
6. Run Grafana using the Grafana Service endpoint.
7. Add Prometheus Datasource
8. Import the Cluster and App Dashboards.