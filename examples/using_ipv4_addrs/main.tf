module "aws_nlb" {
  source         = "../../"
  name           = var.nlb_name
  environment    = var.environment
  logs_s3_bucket = module.nlb_logs.aws_logs_bucket
  nlb_ipv4_addrs = [
    cidrhost(module.vpc.private_subnets_cidr_blocks[0], 10),
    cidrhost(module.vpc.private_subnets_cidr_blocks[1], 10),
    cidrhost(module.vpc.private_subnets_cidr_blocks[2], 10),
  ]
  nlb_subnet_ids = module.vpc.private_subnets
  nlb_vpc_id     = module.vpc.vpc_id
}

module "nlb_logs" {
  source            = "trussworks/logs/aws"
  version           = "~> 10"
  s3_bucket_name    = var.logs_bucket
  nlb_logs_prefixes = ["nlb/${var.nlb_name}-${var.environment}"]
  allow_nlb         = true
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 2"
  cidr            = "10.0.0.0/16"
  azs             = var.vpc_azs
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
