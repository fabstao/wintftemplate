# Landing Zone for Azure

resource "azurerm_network_security_group" "winpoc19nsg1" {
  name                = "winpoc19nsg1"
  resource_group_name = azurerm_resource_group.winpoc19rg.name
  location            = azurerm_resource_group.winpoc19rg.location

  security_rule {
    name                       = "RDP"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.20.0/25"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Windows2019-POC"
    org         = "rps-latam"
  }
}
