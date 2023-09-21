variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_block_1a" {
  type    = string
  default = "10.0.1.0/28"
}

variable "private_subnet_cidr_block_1b" {
  type    = string
  default = "10.0.2.0/28"
}

variable "public_subnet_cidr_block_1a" {
  type    = string
  default = "10.0.3.0/28"
}

variable "public_subnet_cidr_block_1b" {
  type    = string
  default = "10.0.4.0/28"
}

variable "ami_id" {
  type    = string
  default = "ami-0a88b9912c2e7fab2"
}

variable "vpc_tag_name" {
  type    = string
  default = "vpc-webapp"
}

variable "private_subnet1a_tag_name" {
  type    = string
  default = "private-subnet-1a-webapp"
}

variable "private_subnet1b_tag_name" {
  type    = string
  default = "private-subnet-1b-webapp"
}

variable "public_subnet1a_tag_name" {
  type    = string
  default = "public-subnet-1a-webapp"
}

variable "public_subnet1b_tag_name" {
  type    = string
  default = "public-subnet-1b-webapp"
}

variable "igw_tag_name" {
  type    = string
  default = "igw-webapp"
}

variable "asg_lt_tagging" {
  type    = string
  default = "lt-webapp"
}

variable "alb_tagging" {
  type    = string
  default = "alb-webapp"
}