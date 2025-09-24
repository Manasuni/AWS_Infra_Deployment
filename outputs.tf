output "vpc_id" { value = module.vpc.vpc_id }
output "eks_cluster" { value = module.eks.cluster_name }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "redis_endpoint" { value = module.redis.redis_primary_endpoint }
output "static_bucket" { value = module.s3.bucket_id }
