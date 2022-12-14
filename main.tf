provider "aws" {
  region = "us-east-1"

}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.32.0"
    }
  }
}
# locals {
#   az = 
# }
module "vpc" {
  source         = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  Private_subnet = ["10.0.10.0/24", "10.0.20.0/24"]
  Public_subnet  = ["10.0.1.0/24", "10.0.2.0/24"]
  az             = ["us-east-1a", "us-east-1b"]
}
module "ec2" {
  source         = "./EC2"
  vpc            = module.vpc
  sg_public      = module.vpc.sg_public
  subnet_public  = module.vpc.subnet_public
  sg_private     = module.vpc.sg_private
  subnet_private = module.vpc.subnet_private
  az             = ["us-east-1a", "us-east-1b"]


}
module "ALB" {
  source             = "./ALB"
  vpc_id             = module.vpc.vpc_id
  security_group     = module.vpc.sg_alb
  subnets            = module.vpc.subnet_public
  instance_public_id = module.ec2.instance_public_id
}
