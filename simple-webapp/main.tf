terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

module "webapp_vpc" {
  source         = "../module-vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_tagging    = var.vpc_tag_name
  igw_tagging    = var.igw_tag_name
}

module "webapp_private_subnet_1a" {
  source            = "../module-private-subnet"
  vpc_id            = module.webapp_vpc.vpc_id
  subnet_cidr_block = var.private_subnet_cidr_block_1a
  availability_zone = "ap-southeast-1a"
  tagging           = var.private_subnet1a_tag_name

}

module "webapp_private_subnet_1b" {
  source            = "../module-private-subnet"
  vpc_id            = module.webapp_vpc.vpc_id
  subnet_cidr_block = var.private_subnet_cidr_block_1b
  availability_zone = "ap-southeast-1b"
  tagging           = var.private_subnet1b_tag_name
}

module "webapp_public_subnet_1a" {
  source            = "../module-public-subnet"
  vpc_id            = module.webapp_vpc.vpc_id
  subnet_cidr_block = var.public_subnet_cidr_block_1a
  availability_zone = "ap-southeast-1a"
  igw_id            = module.webapp_vpc.igw_id
  tagging           = var.public_subnet1a_tag_name

}

module "webapp_public_subnet_1b" {
  source            = "../module-public-subnet"
  vpc_id            = module.webapp_vpc.vpc_id
  subnet_cidr_block = var.public_subnet_cidr_block_1b
  availability_zone = "ap-southeast-1b"
  igw_id            = module.webapp_vpc.igw_id
  tagging           = var.public_subnet1b_tag_name

}

module "webapp" {
  source         = "../module-webapp"
  vpc_id         = module.webapp_vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block

  ami_id         = var.ami_id // Windows Server 2019 with Apache Tomcat installed image
  asg_lt_tagging = var.asg_lt_tagging

  private_subnet_1a_id = module.webapp_private_subnet_1a.subnet_id
  private_subnet_1b_id = module.webapp_private_subnet_1b.subnet_id
  public_subnet_1a_id  = module.webapp_public_subnet_1a.subnet_id
  public_subnet_1b_id  = module.webapp_public_subnet_1b.subnet_id

  alb_tagging = var.alb_tagging
}
