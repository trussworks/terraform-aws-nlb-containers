<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates a Network Load Balancer (NLB) for serving an ECS backed service.

Creates the following resources:

* NLB associated with 3 Elastic IP addresses.
* TCP listener.
* Target group for the TCP listener over the specified container port.

## Terraform Versions

Terraform 0.12. Pin module version to ~> 2.0.2. Submit pull-requests to master branch.

Terraform 0.11. Pin module version to ~> 1.5.0. Submit pull-requests to terraform011 branch.

## Usage

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

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
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
| nlb\_eip\_ids | List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs. | `list(string)` | n/a | yes |
| nlb\_listener\_port | The port on which the NLB will receive traffic. | `string` | `"443"` | no |
| nlb\_subnet\_ids | Subnets IDs for the NLB. | `list(string)` | n/a | yes |
| nlb\_vpc\_id | VPC ID to be used by the NLB. | `string` | n/a | yes |
| target\_group\_name | Override the default name of the NLB's target group. Must be less than or equal to 32 characters. Default: ecs-[name]-[environment]-[port]. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| nlb\_arn | The ARN of the NLB. |
| nlb\_dns\_name | DNS name of the NLB. |
| nlb\_elastic\_ips | List of public Elastic IP addresses associated with the NLB. |
| nlb\_listener\_arn | The ARN associated with the listener on the NLB. |
| nlb\_target\_group\_id | ID of the NLB target group. |
| nlb\_zone\_id | The canonical hosted zone ID of the load balancer. |

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
