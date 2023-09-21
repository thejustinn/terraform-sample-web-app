resource "aws_vpc" "vpc_obj" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_tagging
  }
}

resource "aws_internet_gateway" "igw_obj" {
  vpc_id = aws_vpc.vpc_obj.id

  tags = {
    Name = var.igw_tagging
  }
}