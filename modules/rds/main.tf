resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-rds-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-${var.environment}-rds"
  engine = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  db_name     = var.db_name
  username = var.db_username
  password = var.db_password   # recommend using SSM securestring; here for example
  multi_az = true
  publicly_accessible = false
  storage_encrypted = true
  kms_key_id = var.kms_key_id
  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot = true
  apply_immediately = true
}
