resource "azurerm_resource_group" "vnet" {
  name     = "rg-${var.project_acronym}-connectivity-${var.subscription_env}-${var.location_shortname}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_acronym}-${var.subscription_env}-${var.location_shortname}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.14.184.0/25"]
  dns_servers         = ["10.7.136.4", "10.14.136.4"]
  tags                = local.tags
}

# Create a route table for the UK West
resource "azurerm_route_table" "rt" {
  name                = "rt-${var.project_acronym}-${var.subscription_env}-${var.location_shortname}"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnet.name
  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.8.16.4"
  }

  tags = local.tags
}
