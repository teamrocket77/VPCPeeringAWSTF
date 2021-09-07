provider "aws" {
    region = "us-east-1"
  
}

module "vpc_1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_1"
  cidr = "10.10.0.0/16"


  azs = ["us-east-1a","us-east-1b","us-east-1c"]

  private_subnets = ["10.10.1.48/28", "10.10.1.64/28", "10.10.1.80/28"]
  public_subnets  = ["10.10.1.0/28", "10.10.1.16/28", "10.10.1.32/28"]
}
module "vpc_2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_2"
  cidr = "10.11.0.0/16"

  azs = ["us-east-1a","us-east-1b","us-east-1c"]
  private_subnets = ["10.11.1.48/28", "10.11.1.64/28", "10.11.1.80/28"]
  public_subnets  = ["10.11.1.0/28", "10.11.1.16/28", "10.11.1.32/28"]
}

# data "aws_vpc" "default"{
#     default =  true
# }

# data "aws_subnet_ids" "this" {
#     vpc_id = data.aws_vpc.default.id
# }

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"


  name            = "vince-test_gw"
#   amazon_side_asn = 67676

  #enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc1 = {
      vpc_id     = module.vpc_1.vpc_id
      subnet_ids = module.vpc_1.private_subnets
    },
    vpc2 = {
      vpc_id     = module.vpc_2.vpc_id
      subnet_ids = module.vpc_2.private_subnets
    }
  }
}