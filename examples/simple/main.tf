module "aws_nlb" {
  source         = "../../"
  name           = var.nlb_name
  environment    = var.environment
  logs_s3_bucket = module.nlb_logs.aws_logs_bucket
  nlb_eip_ids    = aws_eip.nlb[*].id
  nlb_subnet_ids = module.vpc.public_subnets
  nlb_vpc_id     = module.vpc.vpc_id
}

module "nlb_logs" {
  source            = "trussworks/logs/aws"
  version           = "~> 9"
  s3_bucket_name    = var.logs_bucket
  nlb_logs_prefixes = ["nlb/${var.nlb_name}-${var.environment}"]
}

module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "~> 2"
  cidr           = "10.0.0.0/16"
  azs            = var.vpc_azs
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

resource "aws_eip" "nlb" {
  count = 3
  vpc   = true
}
