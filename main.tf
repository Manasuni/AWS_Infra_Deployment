module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = "10.0.0.0/16"
  azs          = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "iam_kms" {
  source       = "./modules/iam_kms"
  project_name = var.project_name
  environment  = var.environment
}

module "s3" {
  source       = "./modules/s3"
  bucket_name = var.bucket_name
  environment  = var.environment
  kms_key_id   = module.iam_kms.kms_key_id
}

module "rds" {
  source           = "./modules/rds"
  project_name     = var.project_name
  environment      = var.environment
  private_subnet_ids = module.vpc.private_subnets
  db_password      = var.db_password
  kms_key_id       = module.iam_kms.kms_key_id
}

module "redis" {
  source = "./modules/redis"
  project_name = var.project_name
  environment  = var.environment
  private_subnet_ids = module.vpc.private_subnets
  kms_key_id = module.iam_kms.kms_key_id
  auth_token = var.redis_auth_token
}

module "eks" {
  source = "./modules/eks"
  project_name = var.project_name
  environment  = var.environment
  private_subnet_ids = module.vpc.private_subnets
  cluster_role_arn = module.iam_kms.eks_role_arn
  node_role_arn    = module.iam_kms.eks_role_arn
}
