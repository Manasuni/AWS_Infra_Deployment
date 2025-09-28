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
  bucket_name  = var.bucket_name
  environment  = var.environment
  kms_key_id   = module.iam_kms.kms_key_arn  # use ARN
}

module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnets
  db_password        = var.db_password
  kms_key_id         = module.iam_kms.kms_key_arn   # use ARN
  engine_version     = "15.14"                       # valid version
}

module "redis" {
  source             = "./modules/redis"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnets
  kms_key_id         = module.iam_kms.kms_key_arn   # use ARN
  auth_token         = var.redis_auth_token
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnets
  cluster_role_arn   = module.iam_kms.eks_role_arn
  node_role_arn      = module.eks.eks_node_role_arn   # <-- this must match EKS module output
  od_desired         = 1
  od_max             = 2
  od_min             = 1
  spot_desired       = 1
  spot_max           = 2
  spot_min           = 1
  node_instance_types = ["t3.medium"]                # example instance type
}
