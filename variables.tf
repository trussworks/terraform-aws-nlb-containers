variable "container_port" {
  description = "The port on which the container will receive traffic."
  type        = "string"
  default     = 443
}

variable "environment" {
  description = "Environment tag, e.g prod."
  type        = "string"
}

variable "enable_proxy_protocol_v2" {
  description = "Boolean to enable / disable support for proxy protocol v2."
  type        = "string"
  default     = "true"
}

variable "name" {
  description = "The service name."
  type        = "string"
}

variable "nlb_eip_ids" {
  description = "List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs."
  type        = "list"
}

variable "nlb_listener_port" {
  description = "The port on which the NLB will receive traffic."
  type        = "string"
  default     = "443"
}

variable "nlb_subnet_ids" {
  description = "Subnets IDs for the NLB."
  type        = "list"
}

variable "nlb_vpc_id" {
  description = "VPC ID to be used by the NLB."
  type        = "string"
}
