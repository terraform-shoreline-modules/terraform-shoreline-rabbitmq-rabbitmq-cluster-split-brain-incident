

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