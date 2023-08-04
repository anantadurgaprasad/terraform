output "public_subnets" {
  value = aws_subnet.public_subnets
}
output "private_subnets" {
  value = aws_subnet.private_subnets
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "jumphost_sg_id" {
  value = aws_security_group.jumphost_sg.id
}
output "jumphost_sg_name" {
  value = aws_security_group.jumphost_sg.name
}
output "rds_sg_id" {
  value = aws_security_group.db_sg.id
}
output "public_subnets_id" {
  value = [
    for a in aws_subnet.public_subnets : a.id
  ]
}