resource "shoreline_notebook" "rabbitmq_cluster_split_brain_incident" {
  name       = "rabbitmq_cluster_split_brain_incident"
  data       = file("${path.module}/data/rabbitmq_cluster_split_brain_incident.json")
  depends_on = [shoreline_action.invoke_ping_rabbitmq_nodes,shoreline_action.invoke_restart_rabbitmq_service,shoreline_action.invoke_rabbitmq_config_update]
}

resource "shoreline_file" "ping_rabbitmq_nodes" {
  name             = "ping_rabbitmq_nodes"
  input_file       = "${path.module}/data/ping_rabbitmq_nodes.sh"
  md5              = filemd5("${path.module}/data/ping_rabbitmq_nodes.sh")
  description      = "Check the network connectivity between RabbitMQ nodes"
  destination_path = "/tmp/ping_rabbitmq_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_rabbitmq_service" {
  name             = "restart_rabbitmq_service"
  input_file       = "${path.module}/data/restart_rabbitmq_service.sh"
  md5              = filemd5("${path.module}/data/restart_rabbitmq_service.sh")
  description      = "Restart the RabbitMQ cluster nodes to resolve the split-brain condition."
  destination_path = "/tmp/restart_rabbitmq_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rabbitmq_config_update" {
  name             = "rabbitmq_config_update"
  input_file       = "${path.module}/data/rabbitmq_config_update.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_config_update.sh")
  description      = "Review the RabbitMQ configuration and adjust the settings to prevent future split-brain scenarios."
  destination_path = "/tmp/rabbitmq_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_rabbitmq_nodes" {
  name        = "invoke_ping_rabbitmq_nodes"
  description = "Check the network connectivity between RabbitMQ nodes"
  command     = "`chmod +x /tmp/ping_rabbitmq_nodes.sh && /tmp/ping_rabbitmq_nodes.sh`"
  params      = ["RABBITMQ_NODE_2","RABBITMQ_NODE_1"]
  file_deps   = ["ping_rabbitmq_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.ping_rabbitmq_nodes]
}

resource "shoreline_action" "invoke_restart_rabbitmq_service" {
  name        = "invoke_restart_rabbitmq_service"
  description = "Restart the RabbitMQ cluster nodes to resolve the split-brain condition."
  command     = "`chmod +x /tmp/restart_rabbitmq_service.sh && /tmp/restart_rabbitmq_service.sh`"
  params      = []
  file_deps   = ["restart_rabbitmq_service"]
  enabled     = true
  depends_on  = [shoreline_file.restart_rabbitmq_service]
}

resource "shoreline_action" "invoke_rabbitmq_config_update" {
  name        = "invoke_rabbitmq_config_update"
  description = "Review the RabbitMQ configuration and adjust the settings to prevent future split-brain scenarios."
  command     = "`chmod +x /tmp/rabbitmq_config_update.sh && /tmp/rabbitmq_config_update.sh`"
  params      = ["RABBITMQ_CONFIG_FILE_PATH","DESIRED_VALUE"]
  file_deps   = ["rabbitmq_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_config_update]
}

