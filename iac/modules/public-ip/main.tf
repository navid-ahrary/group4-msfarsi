resource "azurerm_public_ip" "fwPip" {
  name                = var.fwPipName
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = "Static"
  sku                 = var.Sku
}

resource "azurerm_public_ip" "fwManagementPip" {
  name                = var.fwManagementPipName
  location            = var.location
  resource_group_name = var.rgName
  allocation_method   = "Static"
  sku                 = var.Sku
}

