# Terraform IAM module for roles

resource "aws_iam_role" "provisioner" {
  name = "ci-terraform-provisioner-dev"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = [
          "config.amazonaws.com", # AWS Config needs this
          "ec2.amazonaws.com"     # Terraform running on EC2 may need this
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "scan_runner" {
  name = "ci-scan-runner-dev"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Example IAM policies
resource "aws_iam_role_policy" "provisioner_policy" {
  name   = "provisioner-policy-dev"
  role   = aws_iam_role.provisioner.id
  policy = file("${path.module}/policies/provisioner.json")
}

resource "aws_iam_role_policy" "scan_runner_policy" {
  name   = "scan-runner-policy-dev"
  role   = aws_iam_role.scan_runner.id
  policy = file("${path.module}/policies/scan_runner.json")
}
