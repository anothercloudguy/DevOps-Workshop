
resource "azurerm_postgresql_server" "pgsql_db" {
  name                = var.postgresql_server_name
  location            = azurerm_resource_group.pgsql_db.location
  resource_group_name = "Spacely_Sprockets_Inc"

  sku_name            = "B_Gen5_2"
  storage_mb          = 5120
  backup_retention_days = 7
  administrator_login    = var.postgresql_admin_username
  administrator_login_password = var.postgresql_admin_password
  version              = "11"
  ssl_enforcement_enabled = true
  
  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

resource "azurerm_postgresql_database" "pgsql_db" {
  name                = var.postgresql_database_name
  resource_group_name = azurerm_resource_group.pgsql_db.name
  server_name         = azurerm_postgresql_server.pgsql_db.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "pgsql_db" {
  name                = "allow_all_ips"
  resource_group_name = azurerm_resource_group.pgsql_db.name
  server_name         = azurerm_postgresql_server.pgsql_db.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

output "postgresql_server_fqdn" {
  value = azurerm_postgresql_server.pgsql_db.fqdn
}

output "postgresql_database_name" {
  value = azurerm_postgresql_database.pgsql_db.name
}
