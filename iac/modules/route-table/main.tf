resource "azurerm_route_table" "rt" {
  name = var.routeTableName

  resource_group_name = var.rgName
  location            = var.location
  tags                = var.commonTags
}

resource "azurerm_subnet_route_table_association" "rtAksSubnetAssociation" {
  route_table_id = azurerm_route_table.rt.id
  subnet_id      = var.aksSubnetId
}

resource "azurerm_route" "routeVnet" {
  name                = "route-vnet"
  route_table_name    = azurerm_route_table.rt.name
  address_prefix      = join(",", var.vnetAddressSpaces)
  resource_group_name = var.rgName
  next_hop_type       = var.vnetNextHopeType
}


resource "azurerm_route" "routeInternet" {
  name                = "route-intenet"
  address_prefix      = "${var.fwpip}/32"
  resource_group_name = var.rgName
  route_table_name    = azurerm_route_table.rt.name
  next_hop_type       = "Internet"
}
