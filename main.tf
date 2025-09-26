provider "aws" {
  region = "ap-south-1"
}

module "iam" {
  source      = "./modules/iam"
  role_suffix = "dev"
}

module "config" {
  source   = "./modules/config"
  role_arn = module.iam.provisioner_role_arn
}

module "ssm" {
  source = "./modules/ssm"
}

module "guardduty" {
  source = "./modules/security"
}
