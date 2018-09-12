output "nlb_arn" {
  description = "The ARN of the NLB."
  value       = "${aws_lb.main.arn}"
}

output "nlb_dns_name" {
  description = "DNS name of the NLB."
  value       = "${aws_lb.main.dns_name}"
}

output "nlb_elastic_ips" {
  description = "List of public Elastic IP addresses associated with the NLB."

  value = [
    "${data.aws_eip.nlb_eip1.public_ip}",
    "${data.aws_eip.nlb_eip2.public_ip}",
    "${data.aws_eip.nlb_eip3.public_ip}",
  ]
}

output "nlb_target_group_id" {
  description = "ID of the NLB target group."
  value       = "${aws_lb_target_group.main.id}"
}

output "nlb_listener_arn" {
  description = "The ARN associated with the listener on the NLB."
  value       = "${aws_lb_listener.main.arn}"
}
