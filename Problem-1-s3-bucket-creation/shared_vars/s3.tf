
output "region" {
  value = local.region
}

#############################

locals {
  env = terraform.workspace


  region = {
    default = "us-east-1"
    dev     = "us-east-1"
    qa      = "us-east-1"
    preprod = "us-east-1"
    prod    = "us-east-1"
  }[local.env]
}