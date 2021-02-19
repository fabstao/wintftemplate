# VNETs

resource "azurerm_network_ddos_protection_plan" "ddosplan1" {
  name                = "ddospplan1"
  location            = azurerm_resource_group.winpoc19rg.location
  resource_group_name = azurerm_resource_group.winpoc19rg.name
}


resource "azurerm_virtual_network" "vnetwinpoc19" {
  name                = "vnetwinpoc19"
  resource_group_name = azurerm_resource_group.winpoc19rg.name
  location            = azurerm_resource_group.winpoc19rg.location
  address_space       = ["192.168.0.0/16"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.ddosplan1.id
    enable = true
  }

  tags = {
    org         = "rps-latam"
    environment = "Windows2019-POC"
  }

  depends_on = [azurerm_resource_group.winpoc19rg]
}

resource "azurerm_subnet" "winpoc19sn1" {
  name                 = "winpoc19sn1"
  resource_group_name  = azurerm_resource_group.winpoc19rg.name
  address_prefixes     = ["192.168.20.0/25"]
  virtual_network_name = azurerm_virtual_network.vnetwinpoc19.name
}

resource "azurerm_network_interface_security_group_association" "sgwinpoc19nic" {
  network_interface_id      = azurerm_network_interface.winpoc19nic1.id
  network_security_group_id = azurerm_network_security_group.winpoc19nsg1.id
}

# NAT GATEWAY

# resource "azurerm_nat_gateway" "winpoc19-gw1" {
#  name                = "winpoc19-gw1"
#  location            = azurerm_resource_group.winpoc19rg.location
#  resource_group_name = azurerm_resource_group.winpoc19rg.name
#  tags = {
#    org = "rps-latam"
#  }
#}
