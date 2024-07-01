  resource "azurerm_resource_group" "aks_rg" {
    name     = "Spacely_Sprockets_Inc"
    location = "eastus"
  }
  resource "azurerm_resource_group" "acr_rg" {
    name     = "containerregistryrg"
    location = "eastus"
  }
  resource "azurerm_kubernetes_cluster" "aks" {
    name                = "spacelycluster"
    location            = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    dns_prefix          = "spacelycluster-dns"
    kubernetes_version  = "1.28.9"
    role_based_access_control_enabled = true
    automatic_channel_upgrade           = "patch"
  
    default_node_pool {
        name                          = "agentpool"
        node_count                    = 2
        vm_size                       = "Standard_DSa2_v2"
        os_disk_size_gb               = 128
        enable_auto_scaling           = true
        min_count                     = 1
        max_count                     = 3
        orchestrator_version          = "1.28.9"
        node_labels = {
            "nodepool" = "amd64pool"
        }
        temporary_name_for_rotation   = "agntpooltmp"
      }
  
    network_profile {
      network_plugin     = "azure"
      dns_service_ip     = "10.0.0.10"
      service_cidr       = "10.0.0.0/16"
      load_balancer_sku  = "standard"
      outbound_type      = "loadBalancer"
    }
  
    identity {
      type = "SystemAssigned"
    }
  
    tags = {
      environment = "development"
    }
    maintenance_window_auto_upgrade {
        day_of_month = 0
        day_of_week  = "Sunday"
        duration     = 4
        frequency    = "Weekly"
        interval     = 1
        start_date   = "2024-06-27T00:00:00Z"
        start_time   = "00:00"
        utc_offset   = "+00:00"
      }

    maintenance_window_node_os {
        day_of_month = 0
        day_of_week  = "Sunday"
        duration     = 4
        frequency    = "Weekly"
        interval     = 1
        start_date   = "2024-06-27T00:00:00Z"
        start_time   = "00:00"
        utc_offset   = "+00:00"
    }
  }
  
  resource "azurerm_container_registry" "acr" {
    name                = "spacelysprockets"
    resource_group_name = "containerregistryrg"
    location            = "eastus"
    sku                 = "Basic"
    admin_enabled       = true
  
    tags = {
      environment = "development"
    }
  }
  
  resource "azurerm_role_assignment" "acr_pull" {
    principal_id   = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
    role_definition_name = "AcrPull"
    scope          = azurerm_container_registry.acr.id
  }
 
  
  
  resource "azurerm_log_analytics_workspace" "oms_workspace" {
      allow_resource_only_permissions         = true
      cmk_for_query_forced                    = false
      daily_quota_gb                          = -1
      immediate_data_purge_on_30_days_enabled = false
      internet_ingestion_enabled              = true
      internet_query_enabled                  = true
      local_authentication_disabled           = false
      location                                = "eastus"
      name                                    = "omsnamespace"
      resource_group_name                     = "Spacely_Sprockets_Inc"
      retention_in_days                       = 30
      sku                                     = "PerGB2018"
    }
