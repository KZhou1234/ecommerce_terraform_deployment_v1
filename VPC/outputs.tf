output "vpc_id" {
  
  value = aws_vpc.wl5vpc.id
  #when the vpc module get created, output the vpc id
}

#output both private subnet ids 
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}
#output both public subnet ids 
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}