resource "azurerm_route_table" "rt" {
  name                = var.name
  resource_group_name = var.rgName
  location            = var.location
  tags                = var.commonTags
}

resource "azurerm_subnet_route_table_association" "rtAksSubnetAssociation" {
  route_table_id = azurerm_route_table.rt.id
  subnet_id      = var.aksSubnetId
}

resource "azurerm_route" "routeFw" {
  name                   = "route-fw"
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  resource_group_name    = var.rgName
  next_hop_type          = var.vaNextHopeType
  next_hop_in_ip_address = var.fwPrivateIp
}


resource "azurerm_route" "routeInternet" {
  name                = "route-intenet"
  address_prefix      = "${var.fwpip}/32"
  resource_group_name = var.rgName
  route_table_name    = azurerm_route_table.rt.name
  next_hop_type       = "Internet"
}
