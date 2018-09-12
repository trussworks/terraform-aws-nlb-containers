<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates a Network Load Balancer (NLB) for serving an ECS backed service.

Creates the following resources:

* NLB associated with 3 Elastic IP addresses.
* TCP listener.
* Target group for the TCP listener over the specified container port.


## Usage

```hcl
module "app_nlb" {
  source = "../../modules/aws-nlb-container-service"

  name           = "app"
  environment    = "prod"

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


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| container_port | The port on which the container will receive traffic. | string | `443` | no |
| enable_cross_zone_load_balancing | If true, cross-zone load balancing of the load balancer will be enabled. | string | `true` | no |
| enable_proxy_protocol_v2 | Boolean to enable / disable support for proxy protocol v2. | string | `true` | no |
| environment | Environment tag, e.g prod. | string | - | yes |
| name | The service name. | string | - | yes |
| nlb_eip_ids | List of Elastic IP allocation IDs to associate with the NLB. Requires exactly 3 IPs. | list | - | yes |
| nlb_listener_port | The port on which the NLB will receive traffic. | string | `443` | no |
| nlb_subnet_ids | Subnets IDs for the NLB. | list | - | yes |
| nlb_vpc_id | VPC ID to be used by the NLB. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| nlb_arn | The ARN of the NLB. |
| nlb_dns_name | DNS name of the NLB. |
| nlb_elastic_ips | List of public Elastic IP addresses associated with the NLB. |
| nlb_listener_arn | The ARN associated with the listener on the NLB. |
| nlb_target_group_id | ID of the NLB target group. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

