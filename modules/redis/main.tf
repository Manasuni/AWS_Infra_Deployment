resource "aws_elasticache_subnet_group" "this" {
  name = "${var.project_name}-${var.environment}-redis-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"
  description = "Redis replication group for ${var.environment}"
  engine = "redis"
  node_type = var.node_type
  num_cache_clusters = var.num_nodes
  subnet_group_name = aws_elasticache_subnet_group.this.name
  auth_token = var.auth_token
  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  kms_key_id = var.kms_key_id
}
