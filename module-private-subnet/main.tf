resource "aws_subnet" "subnet_obj" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.tagging
  }
}

resource "aws_route_table" "rt_obj" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.tagging
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.subnet_obj.id
  route_table_id = aws_route_table.rt_obj.id
}