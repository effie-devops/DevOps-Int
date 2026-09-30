output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "ec2_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.public.public_ip
}

output "rds_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}
