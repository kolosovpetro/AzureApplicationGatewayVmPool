resource "azurerm_resource_group" "public" {
  location = var.location
  name     = "rg-agwy-vm-pool-${var.prefix}"
}

#################################################################################################################
# VNET AND SUBNET
#################################################################################################################

resource "azurerm_virtual_network" "public" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "subnet-vm-${var.prefix}"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.0/26"]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "subnet-agw-${var.prefix}"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.0.0.128/26"]
}

#################################################################################################################
# GATEWAY PUBLIC IP
#################################################################################################################

resource "azurerm_public_ip" "gateway_public_ip" {
  name                = "pip-agw-${var.prefix}"
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


#################################################################################################################
# VIRTUAL MACHINES
#################################################################################################################

module "virtual_machine_dev" {
  source                           = "github.com/kolosovpetro/AzureLinuxVMTerraform.git//modules/ubuntu-vm-key-auth-custom-image?ref=master"
  custom_image_resource_group_name = "rg-packer-images-linux"
  custom_image_sku                 = "ubuntu2204-v1"
  ip_configuration_name            = "ipc-dev-${var.prefix}"
  network_interface_name           = "nic-dev-${var.prefix}"
  os_profile_admin_public_key      = file("${path.root}/id_rsa.pub")
  os_profile_admin_username        = "razumovsky_r"
  os_profile_computer_name         = "vm-dev-${var.prefix}"
  public_ip_name                   = "pip-dev-${var.prefix}"
  resource_group_location          = azurerm_resource_group.public.location
  resource_group_name              = azurerm_resource_group.public.name
  storage_os_disk_name             = "osdisk-dev-${var.prefix}"
  subnet_id                        = azurerm_subnet.vm_subnet.id
  vm_name                          = "vm-dev-${var.prefix}"
  network_security_group_id        = azurerm_network_security_group.public.id
}

module "virtual_machine_qa" {
  source                           = "github.com/kolosovpetro/AzureLinuxVMTerraform.git//modules/ubuntu-vm-key-auth-custom-image?ref=master"
  custom_image_resource_group_name = "rg-packer-images-linux"
  custom_image_sku                 = "ubuntu2204-v1"
  ip_configuration_name            = "ipc-qa-${var.prefix}"
  network_interface_name           = "nic-qa-${var.prefix}"
  os_profile_admin_public_key      = file("${path.root}/id_rsa.pub")
  os_profile_admin_username        = "razumovsky_r"
  os_profile_computer_name         = "vm-qa-${var.prefix}"
  public_ip_name                   = "pip-qa-${var.prefix}"
  resource_group_location          = azurerm_resource_group.public.location
  resource_group_name              = azurerm_resource_group.public.name
  storage_os_disk_name             = "osdisk-qa-${var.prefix}"
  subnet_id                        = azurerm_subnet.vm_subnet.id
  vm_name                          = "vm-qa-${var.prefix}"
  network_security_group_id        = azurerm_network_security_group.public.id
}
