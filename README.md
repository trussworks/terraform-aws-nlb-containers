Creates a Network Load Balancer (NLB) for serving an ECS backed service.

Creates the following resources:

- NLB associated with 3 Elastic IP addresses xor 3 IPv4 addresses.
- TCP listener.
- Target group for the TCP listener over the specified container port.

## Terraform Versions

Terraform 0.13 and newer. Pin module version to ~> 4.X. Submit pull-requests to master branch.

Terraform 0.12. Pin module version to ~> 2.X. Submit pull-requests to terraform012 branch.

### Upgrade from 3.x to 4.0.0

Version 4.0.0 added the ability to specify IPv4 addresses instead of elastic IPs. The
`nlb_ipv4_addrs` option was added.

As part of this upgrade, the output variable `nlb_elastic_ips` was renamed to `nlb_ips`. Therefore,
if you use that output variable in your code, you will need to rename it to `nlb_ips`.

## Usage

This module requires attachment to either 3 EIPs (defined with nlb_eip_ids) xor 3 IPv4 addresses
(nlb_ipv4_addrs), but not both EIPs and IPv4 addresses at the same time. If neither option is
defined, the module will fail.

With EIPs:

```hcl
module "app_nlb" {
  source = "trussworks/nlb-containers/aws"

  name           = "app"
  environment    = "prod"
  logs_s3_bucket = "my-aws-logs"

  container_port           = "8443"
  enable_proxy_protocol_v2 = true

  nlb_eip_ids = [
    "eipalloc-0a2306142e1ef53c7",
    "eipalloc-02b30c140722f7659",
    "eipalloc-0e51514ffe125ad3c",
  ]
  nlb_subnet_ids = "${module.vpc.public_subnets}"
  nlb_vpc_id     = "${module.vpc.vpc_id}"
}
```

With IPv4 addresses:

```hcl
module "app_nlb" {
  source = "trussworks/nlb-containers/aws"

  name           = "app"
  environment    = "prod"
  logs_s3_bucket = "my-aws-logs"

  container_port           = "8443"
  enable_proxy_protocol_v2 = true

  nlb_ipv4_addrs = [
    "10.1.1.1",
    "10.1.2.1",
    "10.1.3.1",
  ]
  nlb_subnet_ids = "${module.vpc.public_subnets}"
  nlb_vpc_id     = "${module.vpc.vpc_id}"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_eip.nlb_eip1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |
| [aws_eip.nlb_eip2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |
| [aws_eip.nlb_eip3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_port | The port on which the container will receive traffic. | `string` | `443` | no |
| enable\_cross\_zone\_load\_balancing | If true, cross-zone load balancing of the load balancer will be enabled. | `string` | `true` | no |
| enable\_proxy\_protocol\_v2 | Boolean to enable / disable support for proxy protocol v2. | `string` | `"true"` | no |
| environment | Environment tag, e.g prod. | `string` | n/a | yes |
| health\_check\_interval | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds. | `string` | `30` | no |
| health\_check\_path | When using a HTTP(S) health check, the destination for the health check requests to the container. | `string` | `"/"` | no |
| health\_check\_port | The port on which the container will receive health checks. | `string` | `443` | no |
| health\_check\_protocol | The protocol that will be used for health checks.  Options are: TCP, HTTP, HTTPS | `string` | `"TCP"` | no |
| logs\_s3\_bucket | S3 bucket for storing Network Load Balancer logs.  Access logs are created only if the load balancer has a TLS listener and they contain information only about TLS requests. | `string` | n/a | yes |
| name | The service name. | `string` | n/a | yes |
| nlb\_eip\_ids | Use either this or nlb\_ipv4\_addrs, but not both. List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs. Not compatible with the nlb\_ipv4\_addrs variable. | `list(string)` | `[]` | no |
| nlb\_ipv4\_addrs | Use either this or nlb\_eip\_ids, but not both. List of private IPv4 addresses to associate with the NLB. Requires exactly 3 IPs. Not compatible with the nlb\_eip\_ids variable. | `list(string)` | `[]` | no |
| nlb\_listener\_port | The port on which the NLB will receive traffic. | `string` | `"443"` | no |
| nlb\_subnet\_ids | Subnets IDs for the NLB. | `list(string)` | n/a | yes |
| nlb\_vpc\_id | VPC ID to be used by the NLB. | `string` | n/a | yes |
| target\_group\_name | Override the default name of the NLB's target group. Must be less than or equal to 32 characters. Default: ecs-[name]-[environment]-[port]. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| nlb\_arn | The ARN of the NLB. |
| nlb\_dns\_name | DNS name of the NLB. |
| nlb\_ips | List of IP addresses associated with the NLB. |
| nlb\_listener\_arn | The ARN associated with the listener on the NLB. |
| nlb\_target\_group\_arn | ARN of the NLB target group. |
| nlb\_target\_group\_id | ID of the NLB target group. |
| nlb\_zone\_id | The canonical hosted zone ID of the load balancer. |
<!-- END_TF_DOCS -->

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
```
