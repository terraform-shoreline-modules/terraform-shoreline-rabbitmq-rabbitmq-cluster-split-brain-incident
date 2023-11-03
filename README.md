
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Cluster Split Brain Incident
---

A RabbitMQ Cluster Split Brain incident occurs when a group of RabbitMQ nodes loses connectivity with another group, leading to two separate clusters. This results in message duplication, message loss, and other undesirable consequences. The incident requires immediate attention from the system administrators to fix the problem and restore normal operations.

### Parameters
```shell
export RABBITMQ_NODE_1="PLACEHOLDER"

export RABBITMQ_NODE_2="PLACEHOLDER"

export DESIRED_VALUE="PLACEHOLDER"

export RABBITMQ_CONFIG_FILE_PATH="PLACEHOLDER"
```

## Debug

### Check RabbitMQ cluster status
```shell
rabbitmqctl cluster_status
```

### Check the status of all RabbitMQ nodes in the cluster
```shell
rabbitmqctl cluster_status | grep 'rabbit@'
```

### Check the RabbitMQ logs for any errors or warnings related to the split brain incident
```shell
journalctl -u rabbitmq-server | grep -i 'split brain'
```

### Check the RabbitMQ configuration files for any misconfigurations
```shell
cat /etc/rabbitmq/rabbitmq.config
```

### Check the network connectivity between RabbitMQ nodes
```shell
ping ${RABBITMQ_NODE_1}

ping ${RABBITMQ_NODE_2}
```

### Check the RabbitMQ queues for any inconsistencies or errors
```shell
rabbitmqctl list_queues
```

### Check the RabbitMQ exchange bindings for any inconsistencies or errors
```shell
rabbitmqctl list_bindings
```

### Check the RabbitMQ virtual hosts for any inconsistencies or errors
```shell
rabbitmqctl list_vhosts
```

## Repair

### Restart the RabbitMQ cluster nodes to resolve the split-brain condition.
```shell


#!/bin/bash



# Stop the RabbitMQ service

sudo systemctl stop rabbitmq-server.service



# Wait for a few seconds to ensure the service is fully stopped

sleep 5



# Restart the RabbitMQ service

sudo systemctl start rabbitmq-server.service



# Check the status of the RabbitMQ service

sudo systemctl status rabbitmq-server.service


```

### Review the RabbitMQ configuration and adjust the settings to prevent future split-brain scenarios.
```shell


#!/bin/bash



# Define the RabbitMQ configuration file path

RABBITMQ_CONFIG_FILE=${RABBITMQ_CONFIG_FILE_PATH}



# Backup the existing configuration file

cp $RABBITMQ_CONFIG_FILE $RABBITMQ_CONFIG_FILE.bak



# Adjust the necessary settings to prevent future split-brain scenarios

# For example, you could set the following configuration parameters:

# - cluster_partition_handling = pause_minority

# - net_ticktime = ${DESIRED_VALUE}

# - partition_handling = autoheal

# - autoheal = true

sed -i 's/cluster_partition_handling = .*/cluster_partition_handling = pause_minority/' $RABBITMQ_CONFIG_FILE

sed -i 's/net_ticktime = .*/net_ticktime = ${DESIRED_VALUE}/' $RABBITMQ_CONFIG_FILE

sed -i 's/partition_handling = .*/partition_handling = autoheal/' $RABBITMQ_CONFIG_FILE

sed -i 's/autoheal = .*/autoheal = true/' $RABBITMQ_CONFIG_FILE



# Restart the RabbitMQ service to apply the changes

systemctl restart rabbitmq-server


```