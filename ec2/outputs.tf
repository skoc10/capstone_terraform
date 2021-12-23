#------ ec2/outputs.tf ---

output "network_interface_id" {
  value = aws_instance.app-natinstance.primary_network_interface_id
}