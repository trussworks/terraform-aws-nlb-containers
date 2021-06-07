#
# Locals
#

locals {
  # If using EIPs, the NLB cannot be internal. If it is, the following error will be thrown:
  #    Elastic IPs are not supported for load balancers with scheme 'internal'
  #
  # Similarly, when using the private_ipv4_address field in the subnet_mapping definitions, the
  # scheme must be set to internal.
  #
  # To simplify, internal is set to true if IPv4 addresses are being used, but it could also be
  # determined based on whether or not EIPs are being used.
  internal = local.use_ipv4_addrs

  use_eips       = length(var.nlb_eip_ids) > 0
  use_ipv4_addrs = length(var.nlb_ipv4_addrs) > 0
}

#
# Elastic IP (EIP)
#

data "aws_eip" "nlb_eip1" {
  count = local.use_eips ? 1 : 0

  id = var.nlb_eip_ids[0]
}

data "aws_eip" "nlb_eip2" {
  count = local.use_eips ? 1 : 0

  id = var.nlb_eip_ids[1]
}

data "aws_eip" "nlb_eip3" {
  count = local.use_eips ? 1 : 0

  id = var.nlb_eip_ids[2]
}

#
# Network Load Balancer (NLB)
#

resource "aws_lb" "main" {
  name               = "nlb-${var.name}-${var.environment}"
  load_balancer_type = "network"

  # This option must be explicitly set or else Terraform will attempt to create a public NLB
  # regardless of whether EIPs or private IPv4 addresses are used in the subnet mappings.
  internal = local.internal

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  subnet_mapping {
    subnet_id            = var.nlb_subnet_ids[0]
    allocation_id        = local.use_eips ? var.nlb_eip_ids[0] : null
    private_ipv4_address = local.use_ipv4_addrs ? var.nlb_ipv4_addrs[0] : null
  }

  subnet_mapping {
    subnet_id            = var.nlb_subnet_ids[1]
    allocation_id        = local.use_eips ? var.nlb_eip_ids[1] : null
    private_ipv4_address = local.use_ipv4_addrs ? var.nlb_ipv4_addrs[1] : null
  }

  subnet_mapping {
    subnet_id            = var.nlb_subnet_ids[2]
    allocation_id        = local.use_eips ? var.nlb_eip_ids[2] : null
    private_ipv4_address = local.use_ipv4_addrs ? var.nlb_ipv4_addrs[2] : null
  }

  access_logs {
    enabled = true
    bucket  = var.logs_s3_bucket
    prefix  = "nlb/${var.name}-${var.environment}"
  }

  tags = {
    Environment = var.environment
    Automation  = "Terraform"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.id
  port              = var.nlb_listener_port
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "main" {
  # Name must be less than or equal to 32 characters, or AWS API returns error.
  # Error: "name" cannot be longer than 32 characters
  name = coalesce(var.target_group_name, format("ecs-%s-%s-%s", var.name, var.environment, var.container_port))
  port = var.container_port

  protocol    = "TCP"
  vpc_id      = var.nlb_vpc_id
  target_type = "ip"

  # The amount time for the NLB to wait before changing the state of a
  # deregistering target from draining to unused. Default is 300 seconds.
  deregistration_delay = 90

  # Enable/Disable sending Proxy Protocol V2 headers
  # https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt
  proxy_protocol_v2 = var.enable_proxy_protocol_v2

  # Custom health check timeouts are not supported for health checks for target groups with the TCP protocols.
  health_check {
    interval = var.health_check_interval
    protocol = var.health_check_protocol
    port     = var.health_check_port
    path     = var.health_check_protocol == "HTTP" || var.health_check_protocol == "HTTPS" ? var.health_check_path : ""
  }

  # Ensure the NLB exists before things start referencing this target group.
  depends_on = [aws_lb.main]

  tags = {
    Environment = var.environment
    Automation  = "Terraform"
  }
}
