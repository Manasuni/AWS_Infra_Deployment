variable "role_suffix" {
  type = string
  default = "dev"
}

# IAM role for Terraform provisioner
resource "aws_iam_role" "provisioner" {
  name = "ci-terraform-provisioner-${var.role_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Inline policy for Terraform actions (VPC, EC2, RDS, SSM, Config, GuardDuty)
resource "aws_iam_role_policy" "provisioner_policy" {
  name = "provisioner-policy-${var.role_suffix}"
  role = aws_iam_role.provisioner.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:*",
          "rds:*",
          "vpc:*",
          "ssm:*",
          "config:*",
          "guardduty:*",
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM role for security scan (Gemini mock)
resource "aws_iam_role" "scan_runner" {
  name = "ci-scan-runner-${var.role_suffix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Inline policy for scan runner
resource "aws_iam_role_policy" "scan_runner_policy" {
  name = "ci-scan-runner-policy-${var.role_suffix}"
  role = aws_iam_role.scan_runner.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "config:Describe*",
          "guardduty:Get*",
          "s3:Get*"
        ],
        Resource = "*"
      }
    ]
  })
}
