variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "virtual_network_name" {
  type        = string
  description = "VNet name in Azure"
}

variable "subnet" {
  type        = string
  description = "Subnet name in Azure"
}

variable "vm_name" {
  type        = string
  description = "VM name in Azure"
}

variable "vm_type" {
  type        = string
  default     = "windows2022"
  description = "This is the VM type"
}

# variable "network_security_group" {
#   type        = string
#   description = "NSG"
# }

variable "network_interface" {
  type        = string
  description = "NIC"
}

# variable "company_name" {
#   type        = string
#   description = "company name"
# }

variable "env" {
  default     = "prod"
  description = "Resource environment "
}

# variable "description" {
#   type        = string
#   description = "Application description "
# }

variable "vm_size" {
  type        = string
  description = "VM disk size"
}

variable "storage_account_type" {
  type        = string
  description = "VM disk storage type"
}

variable "rsv" {
  description = "Name of the existing Recovery Services Vault"
  type        = string
}

variable "rsv_rg" {
  description = "Name of the existing Recovery Services Vault"
  type        = string
}

variable "backup_policy" {
  description = "Name of the backup policy in the RSV"
  type        = string
}

variable "domain_name" {
  description = "name of the domain the vm will be joined to"
  type        = string
}

# variable "update_management_rg_name" {
#   type        = string
#   description = "resource group of the update management"
# }

# variable "update_mgmt_schedule_name" {
#   type        = string
#   description = "resource group of the update management"
# }

# variable "automation_account" {
#   type        = string
#   description = "automation account name"
# }

# variable "automation_account_rg" {
#   type        = string
#   description = "automation account rg_name"
# }

variable "defender_policy" {
  type        = string
  description = "Microsoft Defender registration on new VM"
}

variable "domain_username" {
  type        = string
  description = "username of domain user"
}


variable "domain_password" {
  type        = string
  description = "password of domain user"
}
