resource "azurerm_firewall" "fw" {
  name                = var.name
  resource_group_name = var.rgName
  location            = var.location
  sku_tier            = var.fwSkuTier
  sku_name            = var.skuName
  firewall_policy_id  = azurerm_firewall_policy.fwPolicy.id

  ip_configuration {
    name                 = "pipConfig"
    subnet_id            = var.fwSubnetId
    public_ip_address_id = var.fwPipId
  }

  management_ip_configuration {
    name                 = "ipManagementConfig"
    subnet_id            = var.fwManagementSubnetId
    public_ip_address_id = var.fwManagementPipId
  }
}
