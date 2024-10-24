# Resource Group
resource "azurerm_resource_group" "tfrg" {
  name     = "tf-rg"
  location = "Central India"
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "tfstorage" {
  name                     = "tfstorage366"
  resource_group_name      = azurerm_resource_group.tfrg.name
  location                 = azurerm_resource_group.tfrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfcontainer" {
  name                  = "tfcontainer"
  storage_account_name  = azurerm_storage_account.tfstorage.name
  container_access_type = "private"
}

# Virtual Network
resource "azurerm_virtual_network" "tfvnet" {
  name                = "tf-vnet"
  resource_group_name = azurerm_resource_group.tfrg.name
  location            = azurerm_resource_group.tfrg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "tfsubnet" {
  name                 = "tf-subnet"
  resource_group_name  = azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.tfvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "tfnsg" {
  name                = "tf-nsg"
  resource_group_name = azurerm_resource_group.tfrg.name
  location            = azurerm_resource_group.tfrg.location
}

# NSG Rules for SSH, HTTP, HTTPS
resource "azurerm_network_security_rule" "ssh" {
  name                        = "AllowSSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.tfrg.name
  network_security_group_name = azurerm_network_security_group.tfnsg.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "AllowHTTP"
  priority                    = 1002
  resource_group_name         = azurerm_resource_group.tfrg.name
  network_security_group_name = azurerm_network_security_group.tfnsg.name
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "https" {
  name                        = "AllowHTTPS"
  resource_group_name         = azurerm_resource_group.tfrg.name
  network_security_group_name = azurerm_network_security_group.tfnsg.name
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  priority                    = 1003
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Public IP Resource
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "tf-public-ip"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  allocation_method   = "Static"
}

# Network Interface 
resource "azurerm_network_interface" "tfnic" {
  name                = "tf-nic"
  resource_group_name = azurerm_resource_group.tfrg.name
  location            = azurerm_resource_group.tfrg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tfsubnet.id
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet_network_security_group_association" "tf_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.tfsubnet.id
  network_security_group_id = azurerm_network_security_group.tfnsg.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "tfvm" {
  name                  = "tf-vm"
  resource_group_name   = azurerm_resource_group.tfrg.name
  location              = azurerm_resource_group.tfrg.location
  network_interface_ids = [azurerm_network_interface.tfnic.id]
  size                  = "Standard_DS1_v2"

  admin_username = "tfvm"
  admin_password = "server@12345"

  os_disk {
    name    = "myosdisk"
    caching = "ReadWrite"
    # "Premium_LRS" "Standard_LRS" "StandardSSD_LRS" "StandardSSD_ZRS" "Premium_ZRS"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = false
}

