<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates an ALB for serving an HTTPS web app.

Creates the following resources:

* ALB with HTTP (redirect) and HTTPS listeners.
* Target group for the HTTPS listener.
* Security Groups for the ALB.

The HTTP listener redirects to HTTPS.

The HTTPS listener uses a certificate stored in ACM or IAM.

## Usage

```hcl
module "app_alb" {
  source = "../../modules/aws-alb-web-service"

  name           = "app"
  environment    = "prod"
  logs_s3_bucket = "my-aws-logs"

  alb_vpc_id          = "${module.vpc.vpc_id}"
  alb_subnet_ids      = "${module.vpc.public_subnets}"
  alb_certificate_arn = "${aws_acm_certificate.cert.arn}"

  container_port    = "443"
  health_check_path = "/health"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_certificate_arn | The ARN of the certificate to be attached to the ALB. | string | - | yes |
| alb_subnet_ids | Subnets IDs for the ALB. | list | - | yes |
| alb_vpc_id | VPC ID to be used by the ALB. | string | - | yes |
| container_port | The port on which the container will receive traffic. | string | `443` | no |
| container_protocol | The protocol to use to connect with the container. | string | `HTTPS` | no |
| environment | Environment tag, e.g prod. | string | - | yes |
| health_check_path | The destination for the health check requests to the container. | string | `/` | no |
| health_check_success_codes | The HTTP codes to use when checking for a successful response from the container. You can specify multiple values (for example, '200,202') or a range of values (for example, '200-299'). | string | `200` | no |
| logs_s3_bucket | S3 bucket for storing Application Load Balancer logs. | string | - | yes |
| name | The service name. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb_arn | The ARN of the ALB. |
| alb_dns_name | DNS name of the ALB. |
| alb_listener_arn | The ARN associated with the HTTPS listener on the ALB. |
| alb_security_group_id | Security Group ID assigned to the ALB. |
| alb_target_group_id | ID of the target group with the HTTPS listener. |
| alb_zone_id | Route53 hosted zone ID associated with the ALB. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

