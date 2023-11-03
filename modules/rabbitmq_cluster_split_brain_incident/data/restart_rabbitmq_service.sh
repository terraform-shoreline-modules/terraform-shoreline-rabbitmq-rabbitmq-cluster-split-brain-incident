

#!/bin/bash



# Stop the RabbitMQ service

sudo systemctl stop rabbitmq-server.service



# Wait for a few seconds to ensure the service is fully stopped

sleep 5



# Restart the RabbitMQ service

sudo systemctl start rabbitmq-server.service



# Check the status of the RabbitMQ service

sudo systemctl status rabbitmq-server.service