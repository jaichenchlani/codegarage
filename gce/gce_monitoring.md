# GCE Monitoring Info

## Legacy Agent (In use by CentOS webserver)
THIS IS NOT RECOMMEDED. Google recommendation is to use Ops Agent.
https://cloud.google.com/logging/docs/agent/logging/installation
1. `sudo curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh`
2. `sudo bash add-logging-agent-repo.sh --also-install`
3. `sudo yum remove -y google-fluentd-catch-all-config`
4. `sudo yum install -y google-fluentd-catch-all-config-structured`
5. `sudo service google-fluentd restart`

## Ops Agent (In use by Debian webserver)
Installing the monitoring agent
https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent/installation#agent-version-debian-ubuntu
https://cloud.google.com/logging/docs/agent/ops-agent/third-party/apache
1. `curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh`
2. `sudo bash add-google-cloud-ops-agent-repo.sh --also-install`
3. `dpkg-query --show --showformat '${Package} ${Version} ${Architecture} ${Status}\n' google-cloud-ops-agent` Determining the agent version

