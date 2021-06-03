Creates a Network Load Balancer (NLB) for serving an ECS backed service.

Creates the following resources:

* NLB associated with 3 Elastic IP addresses xor 3 IPv4 addresses.
* TCP listener.
* Target group for the TCP listener over the specified container port.

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

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
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port on which the container will receive traffic. | `string` | `443` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | If true, cross-zone load balancing of the load balancer will be enabled. | `string` | `true` | no |
| <a name="input_enable_proxy_protocol_v2"></a> [enable\_proxy\_protocol\_v2](#input\_enable\_proxy\_protocol\_v2) | Boolean to enable / disable support for proxy protocol v2. | `string` | `"true"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag, e.g prod. | `string` | n/a | yes |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds. | `string` | `30` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | When using a HTTP(S) health check, the destination for the health check requests to the container. | `string` | `"/"` | no |
| <a name="input_health_check_port"></a> [health\_check\_port](#input\_health\_check\_port) | The port on which the container will receive health checks. | `string` | `443` | no |
| <a name="input_health_check_protocol"></a> [health\_check\_protocol](#input\_health\_check\_protocol) | The protocol that will be used for health checks.  Options are: TCP, HTTP, HTTPS | `string` | `"TCP"` | no |
| <a name="input_logs_s3_bucket"></a> [logs\_s3\_bucket](#input\_logs\_s3\_bucket) | S3 bucket for storing Network Load Balancer logs.  Access logs are created only if the load balancer has a TLS listener and they contain information only about TLS requests. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The service name. | `string` | n/a | yes |
| <a name="input_nlb_eip_ids"></a> [nlb\_eip\_ids](#input\_nlb\_eip\_ids) | Use either this or nlb\_ipv4\_addrs, but not both. List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs. Not compatible with the nlb\_ipv4\_addrs variable. | `list(string)` | `[]` | no |
| <a name="input_nlb_ipv4_addrs"></a> [nlb\_ipv4\_addrs](#input\_nlb\_ipv4\_addrs) | Use either this or nlb\_eip\_ids, but not both. List of private IPv4 addresses to associate with the NLB. Requires exactly 3 IPs. Not compatible with the nlb\_eip\_ids variable. | `list(string)` | `[]` | no |
| <a name="input_nlb_listener_port"></a> [nlb\_listener\_port](#input\_nlb\_listener\_port) | The port on which the NLB will receive traffic. | `string` | `"443"` | no |
| <a name="input_nlb_subnet_ids"></a> [nlb\_subnet\_ids](#input\_nlb\_subnet\_ids) | Subnets IDs for the NLB. | `list(string)` | n/a | yes |
| <a name="input_nlb_vpc_id"></a> [nlb\_vpc\_id](#input\_nlb\_vpc\_id) | VPC ID to be used by the NLB. | `string` | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Override the default name of the NLB's target group. Must be less than or equal to 32 characters. Default: ecs-[name]-[environment]-[port]. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nlb_arn"></a> [nlb\_arn](#output\_nlb\_arn) | The ARN of the NLB. |
| <a name="output_nlb_dns_name"></a> [nlb\_dns\_name](#output\_nlb\_dns\_name) | DNS name of the NLB. |
| <a name="output_nlb_ips"></a> [nlb\_ips](#output\_nlb\_ips) | List of IP addresses associated with the NLB. |
| <a name="output_nlb_listener_arn"></a> [nlb\_listener\_arn](#output\_nlb\_listener\_arn) | The ARN associated with the listener on the NLB. |
| <a name="output_nlb_target_group_id"></a> [nlb\_target\_group\_id](#output\_nlb\_target\_group\_id) | ID of the NLB target group. |
| <a name="output_nlb_zone_id"></a> [nlb\_zone\_id](#output\_nlb\_zone\_id) | The canonical hosted zone ID of the load balancer. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
```

### Testing

[Terratest](https://github.com/gruntwork-io/terratest) is being used for
automated testing with this module. Tests in the `test` folder can be run
locally by running the following command:

```text
make test
```

Or with aws-vault:

```text
AWS_VAULT_KEYCHAIN_NAME=<NAME> aws-vault exec <PROFILE> -- make test
```
