output "nlb_arn" {
  description = "The ARN of the NLB."
  value       = aws_lb.main.arn
}

output "nlb_dns_name" {
  description = "DNS name of the NLB."
  value       = aws_lb.main.dns_name
}

output "nlb_ips" {
  description = "List of IP addresses associated with the NLB."

  value = [
    local.use_eips ? data.aws_eip.nlb_eip1[0].public_ip : local.use_ipv4_addrs ? var.nlb_ipv4_addrs[0] : "undefined",
    local.use_eips ? data.aws_eip.nlb_eip2[0].public_ip : local.use_ipv4_addrs ? var.nlb_ipv4_addrs[1] : "undefined",
    local.use_eips ? data.aws_eip.nlb_eip3[0].public_ip : local.use_ipv4_addrs ? var.nlb_ipv4_addrs[2] : "undefined",
  ]
}

output "nlb_listener_arn" {
  description = "The ARN associated with the listener on the NLB."
  value       = aws_lb_listener.main.arn
}

output "nlb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer."
  value       = aws_lb.main.zone_id
}

output "nlb_target_group_arn" {
  description = "ARN of the NLB target group."
  value       = aws_lb_target_group.main.arn
}

output "nlb_target_group_id" {
  description = "ID of the NLB target group."
  value       = aws_lb_target_group.main.id
}
