############################################################################
# Common variables
############################################################################
variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "region" {
  description = "Region in which aws resources will be created"
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

############################################################################
# VPC variables
############################################################################
variable "availability_zones" {
  type        = list(string)
  description = "If this variable is not specified, then by default, subnets will be created in each availability zone"
  default     = ["null"]
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private-subnet-a", "private-subnet-b", "private-subnet-c"]
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "public_subnet_names" {
  type    = list(string)
  default = ["public-subnet-a", "public-subnet-b", "public-subnet-c"]
}

variable "public_subnet_tags" {
  description = "A map of tags to add to public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "A map of tags to add to private subnets"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
}

variable "vpc_tags" {
  description = "A map of tags to add to vpc"
  type        = map(string)
  default     = {}
}

##############

locals {
  prefix = var.app_name
  common_tags = {
    "tr:environment-type" = var.tr_environment_type
    "tr:resource-owner"   = var.tr_resource_owner
  }
}

############################################################################
# ECS variables
############################################################################

variable "aws_ecs_cluster" {
  description = "ECS fargate cluster name"
}

#######################################################################
# Load balancer variables
#######################################################################
variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
}

#variable "domain_name" {
#description = "Specify domain name for your acm certificate"
#}

variable "health_check_enabled" {
  description = "Indicates whether health checks are enabled"
}

variable "health_check_path" {
  description = "(Required for HTTP/HTTPS ALB) The destination for the health check request. Applies to Application Load Balancers only (HTTP/HTTPS), not Network Load Balancers (TCP)"
}

variable "healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda"
}

variable "listener_port" {
  description = "Specify a value from 1 to 65535 so that load balancer can listen to that port"
}

variable "listener_protocol" {
  description = "Specify the protocol for load balancer listener"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
}

variable "target_protocol" {
  description = "Target protocol so that load balancer can reach to targets with specified protocol"
}

variable "target_port" {
  description = "Target port so that load balancer can reach to targets from specified port"
}

variable "target_type" {
  description = "Target type for the load balancer target_group"
}

variable "timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks"
}

variable "unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy . For Network Load Balancers, this value must be the same as the healthy_threshold"
}

variable "memory" {}
variable "cpu" {}
variable "ecs_task_definition" {}
variable "network_mode" {
  description = "Network mode for fargate"
}

variable "cloud_watch_logs" {
  description = "Cloud watch logs for instance"
}

variable "ecs_role" {
  description = "ecs role for your ecs instance."
}

variable "ecs_sg" {
  description = "Security group for your ECS container"
}

variable "ecs_image" {
  description = "ecs image for container."
}

variable "containter_port" {
  description = ""
}

variable "my_env_variables"{
  default = [
        {
          "name": "USERNAME",
          "value": "admin"
        },
        {
          "name": "PASSWORD",
          "value": "admin"
        },
        {
          "name": "LICENSE_KEY",
          "value": "KUAW-7GDS-90LO-BA29-VKD1"
        }
      ]
}

