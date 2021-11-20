provider "aws" {
  region  = module.shared_vars.region
  profile = var.profile
}

module "shared_vars" {
  source = "./shared_vars"
}

variable "profile" {    
  type        = string
  description = "enter the aws profile name"
}

variable "versioning_enabled" {
  type        = bool
  description = "do you want to enable versioning ? (true/false)"

  validation {
    condition     = contains(["true", "false"], var.verioning_enabled)
    error_message = "ERROR: Valid values for var: verioning_enabled are (true, false)?"
  }
}

variable "log_intervel" {
  type        = string
  description = "please mention the log intervel.. (hourly/daily/weekly)"

  validation {
    condition     = contains(["hourly", "daily", "weekly"], var.log_intervel)
    error_message = "ERROR: Valid values for var: log_intervel are (hourly, daily, weekly)?"
  }
}
locals {
  env             = terraform.workspace
  product         = "friday-insurance"
  application_tag = "logs-collector"
}

module "storage" {
  source          = "./storage"
  product         = local.product
  application_tag = local.application_tag
  versioning      = var.versioning_enabled
  log_intervel    = var.log_intervel
}
