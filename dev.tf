/*====
Variables used across all modules
======*/
locals {
  dev_availability_zones = ["${var.region}a", "${var.region}b"]
  environment            = "dev"
}

module "networking" {
  source = "./modules/networking"

  region               = var.region
  environment          = var.environment
  availability_zones   = local.dev_availability_zones
}

module "databases" {
  source = "./modules/database"

  availability_zone = local.dev_availability_zones[0]
  subnet_group_name = module.networking.db_subnet_group_name
  db_username       = var.db_username
  db_password       = var.db_password
  environment       = local.environment
  vpc_id            = module.networking.vpc_id
}

module "s3" {
  source = "./modules/s3"

  environment = local.environment
}