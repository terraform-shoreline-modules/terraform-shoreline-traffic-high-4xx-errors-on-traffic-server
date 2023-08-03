resource "shoreline_notebook" "high_4xx_errors_on_traffic_server" {
  name       = "high_4xx_errors_on_traffic_server"
  data       = file("${path.module}/data/high_4xx_errors_on_traffic_server.json")
  depends_on = [shoreline_action.invoke_log_error_check,shoreline_action.invoke_scale_up_deployment,shoreline_action.invoke_optimize_traffic_server_configuration]
}

resource "shoreline_file" "log_error_check" {
  name             = "log_error_check"
  input_file       = "${path.module}/data/log_error_check.sh"
  md5              = filemd5("${path.module}/data/log_error_check.sh")
  description      = "Check the exit code of the grep command to see if any 4xx errors were found"
  destination_path = "/agent/scripts/log_error_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "scale_up_deployment" {
  name             = "scale_up_deployment"
  input_file       = "${path.module}/data/scale_up_deployment.sh"
  md5              = filemd5("${path.module}/data/scale_up_deployment.sh")
  description      = "Increase the server capacity to handle the increased traffic, if applicable."
  destination_path = "/agent/scripts/scale_up_deployment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "optimize_traffic_server_configuration" {
  name             = "optimize_traffic_server_configuration"
  input_file       = "${path.module}/data/optimize_traffic_server_configuration.sh"
  md5              = filemd5("${path.module}/data/optimize_traffic_server_configuration.sh")
  description      = "Optimize the Traffic Server configuration to improve performance and reduce the number of 4xx errors."
  destination_path = "/agent/scripts/optimize_traffic_server_configuration.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_log_error_check" {
  name        = "invoke_log_error_check"
  description = "Check the exit code of the grep command to see if any 4xx errors were found"
  command     = "`chmod +x /agent/scripts/log_error_check.sh && /agent/scripts/log_error_check.sh`"
  params      = []
  file_deps   = ["log_error_check"]
  enabled     = true
  depends_on  = [shoreline_file.log_error_check]
}

resource "shoreline_action" "invoke_scale_up_deployment" {
  name        = "invoke_scale_up_deployment"
  description = "Increase the server capacity to handle the increased traffic, if applicable."
  command     = "`chmod +x /agent/scripts/scale_up_deployment.sh && /agent/scripts/scale_up_deployment.sh`"
  params      = ["DEPLOYMENT_NAME","NAMESPACE"]
  file_deps   = ["scale_up_deployment"]
  enabled     = true
  depends_on  = [shoreline_file.scale_up_deployment]
}

resource "shoreline_action" "invoke_optimize_traffic_server_configuration" {
  name        = "invoke_optimize_traffic_server_configuration"
  description = "Optimize the Traffic Server configuration to improve performance and reduce the number of 4xx errors."
  command     = "`chmod +x /agent/scripts/optimize_traffic_server_configuration.sh && /agent/scripts/optimize_traffic_server_configuration.sh`"
  params      = ["NAMESPACE"]
  file_deps   = ["optimize_traffic_server_configuration"]
  enabled     = true
  depends_on  = [shoreline_file.optimize_traffic_server_configuration]
}

