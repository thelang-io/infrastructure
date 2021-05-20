output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.the-api-ec2.id
}
