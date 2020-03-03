#
# Elastic IP (EIP)
#

data "aws_eip" "nlb_eip1" {
  id = var.nlb_eip_ids[0]
}

data "aws_eip" "nlb_eip2" {
  id = var.nlb_eip_ids[1]
}

data "aws_eip" "nlb_eip3" {
  id = var.nlb_eip_ids[2]
}

#
# Network Load Balancer (NLB)
#

resource "aws_lb" "main" {
  name               = "nlb-${var.name}-${var.environment}"
  load_balancer_type = "network"

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  subnet_mapping {
    subnet_id     = var.nlb_subnet_ids[0]
    allocation_id = var.nlb_eip_ids[0]
  }

  subnet_mapping {
    subnet_id     = var.nlb_subnet_ids[1]
    allocation_id = var.nlb_eip_ids[1]
  }

  subnet_mapping {
    subnet_id     = var.nlb_subnet_ids[2]
    allocation_id = var.nlb_eip_ids[2]
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
