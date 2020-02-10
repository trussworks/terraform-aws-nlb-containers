variable "container_port" {
  description = "The port on which the container will receive traffic."
  default     = 443
  type        = string
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  type        = string
  default     = 30
}

variable "health_check_path" {
  description = "When using a HTTP(S) health check, the destination for the health check requests to the container."
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port on which the container will receive health checks."
  default     = 443
  type        = string
}

variable "health_check_protocol" {
  description = "The protocol that will be used for health checks.  Options are: TCP, HTTP, HTTPS"
  default     = "TCP"
  type        = string
}

variable "health_check_timeout" {
  description = "The health check timeout. Minimum value 2 seconds, Maximum value 60 seconds. Default 5 seconds."
  type        = string
  default     = 5
}

variable "environment" {
  description = "Environment tag, e.g prod."
  type        = string
}

variable "logs_s3_bucket" {
  description = "S3 bucket for storing Network Load Balancer logs."
  type        = string
}

variable "enable_proxy_protocol_v2" {
  description = "Boolean to enable / disable support for proxy protocol v2."
  default     = "true"
  type        = string
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled."
  default     = true
  type        = string
}

variable "name" {
  description = "The service name."
  type        = string
}

variable "nlb_eip_ids" {
  description = "List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs."
  type        = list(string)
}

variable "nlb_listener_port" {
  description = "The port on which the NLB will receive traffic."
  default     = "443"
  type        = string
}

variable "nlb_subnet_ids" {
  description = "Subnets IDs for the NLB."
  type        = list(string)
}

variable "nlb_vpc_id" {
  description = "VPC ID to be used by the NLB."
  type        = string
}

variable "target_group_name" {
  description = "Override the default name of the NLB's target group. Must be less than or equal to 32 characters. Default: ecs-[name]-[environment]-[port]."
  type        = string
  default     = ""
}
