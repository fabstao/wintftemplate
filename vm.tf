# Virtual Machines

## rke masters

### Master 1

resource "azurerm_public_ip" "winpoc2019pip" {
  name                = "winpoc2019pip"
  resource_group_name = azurerm_resource_group.winpoc19rg.name
  location            = azurerm_resource_group.winpoc19rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Windows2019-POC"
    org         = "rps-latam"
  }
}

resource "azurerm_network_interface" "winpoc2019nic1" {
  name                = "winpoc2019nic1"
  location            = azurerm_resource_group.winpoc19rg.location
  resource_group_name = azurerm_resource_group.winpoc19rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rke1sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.winpoc2019pip.id
  }
  tags = {
    environment = "Windows2019-POC"
    org         = "rps-latam"
  }
}

resource "azurerm_windows_virtual_machine" "winpoc2019" {
  name                = "winpoc2019"
  resource_group_name = azurerm_resource_group.winpoc19rg.name
  location            = azurerm_resource_group.winpoc19rg.location
  size                = "Standard_A4_v2"
  admin_username      = "fabs"
  admin_password      = "Rackspace@2020"
  network_interface_ids = [
    azurerm_network_interface.winpoc2019nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = {
    environment = "Windows2019-POC"
    org         = "rps-latam"
  }
}

# BASTION Host

resource "azurerm_bastion_host" "win19bastion" {
  name                = "win19bastion"
  location            = azurerm_resource_group.winpoc19rg.location
  resource_group_name = azurerm_resource_group.winpoc19rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.winpoc19sn.id
    public_ip_address_id = azurerm_public_ip.winpoc19pip.id
  }
}
