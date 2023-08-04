This script outputs namespaces, Pods, all disk space, used and free disk space, and the percentage of disk space used in running Kubernetes cluster pods

The script saves all the data in the log to the ~/logs/ directory
In my project, the script was configured to send data to the zabbix server.

On any VM where the kubectl utility is installed (if necessary, it can be installed on any VM), we create a script, for example in the home directory:
vi ~/k8s_space_pgsql_pod.sh

Copy the contents of the script into it and save it.

Making the script executable:
chmod +x ~/k8s_space_pgsql_pod.sh

Running the script:
~/k8s_space_pgsql_pod.sh
