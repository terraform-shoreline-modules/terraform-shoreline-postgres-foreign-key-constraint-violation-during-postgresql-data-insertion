terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "foreign_key_constraint_violation_during_postgresql_data_insertion" {
  source    = "./modules/foreign_key_constraint_violation_during_postgresql_data_insertion"

  providers = {
    shoreline = shoreline
  }
}