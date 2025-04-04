output "agwy_public_ip" {
  value = azurerm_public_ip.gateway_public_ip.ip_address
}

output "ssh_command_dev" {
  value = "ssh razumovsky_r@${module.virtual_machine_dev.public_ip}"
}

output "dev_public_ip" {
  value = module.virtual_machine_dev.public_ip
}

output "qa_public_ip" {
  value = module.virtual_machine_qa.public_ip
}

output "ssh_command_qa" {
  value = "ssh razumovsky_r@${module.virtual_machine_qa.public_ip}"
}

output "copy_temp_command_dev" {
  value = "scp ./html/blue.html razumovsky_r@${module.virtual_machine_dev.public_ip}:/tmp/blue.html"
}

output "copy_nginx_dev" {
  value = "ssh razumovsky_r@${module.virtual_machine_dev.public_ip} \"sudo cp /tmp/blue.html /var/www/html/index.nginx-debian.html && sudo systemctl restart nginx\""
}

output "copy_temp_command_qa" {
  value = "scp ./html/green.html razumovsky_r@${module.virtual_machine_qa.public_ip}:/tmp/green.html"
}

output "copy_nginx_qa" {
  value = "ssh razumovsky_r@${module.virtual_machine_qa.public_ip} \"sudo cp /tmp/green.html /var/www/html/index.nginx-debian.html && sudo systemctl restart nginx\""
}