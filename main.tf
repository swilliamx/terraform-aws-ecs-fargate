module "aws-vpc" {
  source                     = "./modules/aws-vpc"
  availability_zones         = var.availability_zones
  app_name                   = var.app_name
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_subnet_names       = var.private_subnet_names
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  public_subnet_names        = var.public_subnet_names
  public_subnet_tags         = var.public_subnet_tags
  private_subnet_tags        = var.private_subnet_tags
  tr_environment_type        = var.tr_environment_type
  tr_resource_owner          = var.tr_resource_owner
  vpc_cidr                   = var.vpc_cidr
  vpc_tags                   = var.vpc_tags
}