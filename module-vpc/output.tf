output "vpc_id" {
  value = aws_vpc.vpc_obj.id
}

output "igw_id" {
  value = aws_internet_gateway.igw_obj.id
}