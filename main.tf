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

resource "azurerm_subnet" "internal" {
  name                 = "subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.public.name
  virtual_network_name = azurerm_virtual_network.public.name
  address_prefixes     = ["10.10.0.0/26"]
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
  subnet_id                        = azurerm_subnet.internal.id
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
  subnet_id                        = azurerm_subnet.internal.id
  vm_name                          = "vm-qa-${var.prefix}"
  network_security_group_id        = azurerm_network_security_group.public.id
}

#################################################################################################################
# NETWORK SECURITY GROUP
#################################################################################################################

resource "azurerm_network_security_group" "public" {
  name                = "nsg-${var.prefix}"
  location            = azurerm_resource_group.public.location
  resource_group_name = azurerm_resource_group.public.name
}

resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "AllowRDP"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.public.name
  network_security_group_name = azurerm_network_security_group.public.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.public.name
  network_security_group_name = azurerm_network_security_group.public.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "AllowHTTP"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.public.name
  network_security_group_name = azurerm_network_security_group.public.name
}

resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 1030
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.public.name
  network_security_group_name = azurerm_network_security_group.public.name
}

resource "azurerm_network_security_rule" "allow_sql_server" {
  name                        = "AllowSQLServer"
  priority                    = 1040
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.public.name
  network_security_group_name = azurerm_network_security_group.public.name
}
