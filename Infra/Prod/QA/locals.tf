locals {
  environment = "qa"
  project     = "prod"

  # Naming convention
  rg_name     = "${local.project}-${local.environment}-rg"
  aks_name    = "${local.project}-${local.environment}-aks"
  vnet_name   = "${local.project}-${local.environment}-vnet"
  subnet_name = "${local.project}-${local.environment}-aks-subnet"
  pip_name    = "${local.project}-${local.environment}-pip"
  appgw_name  = "${local.project}-${local.environment}-agw"
  acr_name    = "${local.project}${local.environment}acr01"

  tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "Terraform"
  }
}
