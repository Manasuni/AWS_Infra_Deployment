# KMS key for RDS/S3/Redis
resource "aws_kms_key" "this" {
  description = "KMS key for ${var.project_name}-${var.environment}"
  deletion_window_in_days = 30
  tags = { Name = "${var.project_name}-${var.environment}-kms" }
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

data "aws_iam_policy_document" "eks_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}
# Additional roles/policies for node groups, CI/CD can be added similarly
