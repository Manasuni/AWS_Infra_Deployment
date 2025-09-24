resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-${var.environment}-eks"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_public_access = true
  }

  depends_on = []
}

resource "aws_eks_node_group" "ng_spot" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.environment}-spot-ng"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.spot_desired
    max_size     = var.spot_max
    min_size     = var.spot_min
  }

  capacity_type = "SPOT"
  instance_types = var.node_instance_types
}

resource "aws_eks_node_group" "ng_on_demand" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.environment}-od-ng"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.od_desired
    max_size     = var.od_max
    min_size     = var.od_min
  }

  capacity_type = "ON_DEMAND"
  instance_types = var.node_instance_types
}
