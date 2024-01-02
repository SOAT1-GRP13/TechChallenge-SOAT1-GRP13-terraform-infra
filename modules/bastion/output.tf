output "bastion_security_group" {
  description = "security group of EC2 bastion host"
  value       = aws_security_group.ec2-bastion-sg.id
}

output "ec2_dns" {
  description = "security group of EC2 bastion host"
  value       = aws_instance.ec2-bastion-host.public_dns
}