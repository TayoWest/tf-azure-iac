###################################
###        DATA SOURCES         ###
###################################

#VM AND SUBNET RG
data "azurerm_resource_group" "resource_group_name"  {
  name  = var.resource_group_name
}

#DEFENDER POLICY DEFINITION
data "azurerm_policy_definition" "defender_policy" {
  name = var.defender_policy
}

#VM BACKUP POLICY
data "azurerm_backup_policy_vm" "backup_policy" {
  name                = var.backup_policy
  resource_group_name = var.rsv_rg
  recovery_vault_name = var.rsv
}

#SUBNET
data "azurerm_subnet" "subnet" {
  name                 = var.subnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

#VM MODULE

module "wcc_vm_one" {
  source = "../modules"
  vm_name = var.vm_name
  location = var.location
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet = var.subnet
  vm_type = var.vm_type
  vm_size = var.vm_size
  network_interface = var.network_interface
  storage_account_type = var.storage_account_type
  rsv = var.rsv
  rsv_rg = var.rsv_rg
  # computer_name = var.vm_name
  # recovery_vault_name = var.rsv
  domain_name = var.domain_name
  backup_policy = var.backup_policy
  defender_policy = var.defender_policy
  domain_username = var.domain_username
  domain_password = var.domain_password
}


#TIP ANY PROPERTY YOU DEFINED IN MAIN.TF 
#IN MODULE IS WHAT YOU REFERENCE HERE
