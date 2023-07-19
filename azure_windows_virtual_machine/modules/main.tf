# Generate a random password
resource "random_string" "password" {
  length      = 16
  upper       = true
  min_upper   = 1
  lower       = true
  min_lower   = 1
  numeric      = true
  min_numeric = 1
  special     = false
}

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

###################################
###       VIRTUAL MACHINES      ###
###################################

resource "azurerm_virtual_machine" "vm_name" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = "w2k22-${var.vm_name}"
    admin_password = random_string.password.result
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = true
  }

  network_interface_ids = [azurerm_network_interface.network_interface.id]

  tags = {
    BillingContact  = "dliu@westminster.gov.uk"
    BusinessOwner   = "dliu@westminster.gov.uk"
    BusinessService = "Infrastructure Services"
    Classification  = ""
    CostCode        = "BAU1234"
    Creator         = "tayodele@westminster.gov.uk"
    Criticality     = "High"
    Deployment      = "Terraform"
    Directorate     = "Technical Services"
    Environment     = "Prod"
    Owner           = "dliu@westminster.gov.uk"
    ProjectCode     = "012345p"
  }
}

# Create network interface
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.vm_name}${var.env}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}${var.env}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

output "password" {
  value = random_string.password.result
}

#RSV

# Add VM to existing backup policy in an existing recovery services vault
resource "azurerm_backup_protected_vm" "vm_name" {
  resource_group_name = "WCC_TEST"
  recovery_vault_name = var.rsv
  source_vm_id        = azurerm_virtual_machine.vm_name.id
  backup_policy_id    = data.azurerm_backup_policy_vm.backup_policy.id
}

# Join VM to domain
resource "azurerm_virtual_machine_extension" "domain_name" {
  name                 = var.domain_name
  virtual_machine_id   = azurerm_virtual_machine.vm_name.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
  {
    "Name": "${var.domain_name}",
    "UserOUPath": "OU=ExampleOU",
    "DomainControllerIPAddress": "10.21.30.84, 10.21.30.85",
    "User": "${var.domain_username}",
    "Restart": "true",
    "Options": "3"
  }
  SETTINGS
   protected_settings = <<PROTECTED_SETTINGS
      {
        "Password": "${var.domain_password}"
      }
    PROTECTED_SETTINGS
}

# # Add VM to existing update management deployment schedule in a different resource group
# resource "azurerm_update_management_schedule" "vm_name" {
#   virtual_machine_id               = azurerm_virtual_machine.vm_name.id
#   update_management_rg_name       = var.update_mgmt_rg_name
#   update_management_schedule_name = var.update_mgmt_schedule_name
#   deployment_schedule_name         = "ExampleDeploymentSchedule"
# }

# resource "azurerm_resource_policy_assignment" "vm_name" {
#   name                 = "windowsdefender_for_servers"
#   resource_id          = azurerm_virtual_machine.vm_name.id
#   policy_definition_id = data.azurerm_policy_definition.defender_policy.id
# }